define(function (require) {

    var Marionette = require('marionette'),
        EditRow = require('./rows/editRow'),
        ViewRow = require('./rows/viewRow'),
        _ = require('underscore');

    return Marionette.CollectionView.extend({

        template: require('hbs!./content'),
        itemView: true,

        initialize: function () {
            this.order = [];
            this.states = {}; // model cid to state
            this.selected = null; // model's cid
            this.addListeners();
        },

        onKeyUp: function (e) {
            var self = this,
                currentIndex = this.selected ? self.order.indexOf(this.selected) : -1;

            switch (e.keyCode) {
                // UP
                case 104:
                case 38:
                    if (this.selected) {
                        if (currentIndex > 0) {
                            this.getSelectedView().$el.removeClass('selected');
                            this.selected = this.children.find(function (view) {
                                return view.model.cid === self.order[currentIndex - 1];
                            }).model.cid;
                            this.getSelectedView().$el.addClass('selected');
                        }
                    } else {
                        this.selected = this.order[this.order.length - 1] ? this.children.find(function (view) {
                            return view.model.cid === self.order[self.order.length - 1];
                        }).model.cid : null;

                        if (this.selected) {
                            this.getSelectedView().$el.addClass('selected');
                        }
                    }
                    break;

                // DOWN
                case 40:
                case 98:
                    if (this.selected) {
                        if (this.children.length - 1 > currentIndex) {
                            this.getSelectedView().$el.removeClass('selected');
                            this.selected = this.children.find(function (view) {
                                return view.model.cid === self.order[currentIndex + 1];
                            }).model.cid;
                            this.getSelectedView().$el.addClass('selected');
                        }
                    } else {
                        this.selected = this.order[0] ? this.children.find(function (view) {
                            return view.model.cid === self.order[0];
                        }).model.cid : null;

                        if (this.selected) {
                            this.getSelectedView().$el.addClass('selected');
                        }
                    }
                    break;

                // ESC
                case 27:
                    if (this.selected) {
                        this.getSelectedView().$el.removeClass('selected');
                        this.selected = null;
                    }
                    break;
            }
        },

        getSelectedView: function () {
            var self = this;
            return this.children.find(function (view) {
                return view.model.cid === self.selected;
            });
        },

        addListeners: function () {
            this.listenTo(this.collection, 'remove', this.updateOrder, this);
            this.listenTo(this, 'render', function () {
                $(document).on('keyup', _.bind(this.onKeyUp, this));
            }, this);
            this.listenTo(this, 'close', function () {
                $(document).off('keyup', _.bind(this.onKeyUp, this));
            }, this);
        },

        // @Override
        renderItemView: function (view, index) {
            view.render(index);
            this.appendHtml(this, view, index);
        },

        // @Override
        appendHtml: function (collectionView, itemView, index) {
            var children = collectionView.$el.children();

            if (collectionView.isBuffering) {
                collectionView.elBuffer.appendChild(itemView.el);
                collectionView._bufferedChildren.push(itemView);
            } else {
                if (index > 0) {
                    children.eq(index - 1).after(itemView.el);
                } else {
                    if (children.length) {
                        children.eq(index).before(itemView.el);
                    } else {
                        collectionView.$el.append(itemView.el);
                    }
                }

            }
        },

        buildItemView: function (model, View, options) {
            var ItemView,
                state = this.getState(options);

            if (state === 'view') {
                ItemView = ViewRow;
            } else if (state === 'edit') {
                ItemView = EditRow;
            } else {
                throw 'Unknown state: ' + this.options.state;
            }

            var row = new ItemView({
                model: model,
                columns: this.options.columns,
                items: this.options.collection,
                editable: this.options.editable,
                onSave: this.options.onSave,
                onDelete: this.options.onDelete,
                numerable: this.options.numerable,
                state: state
            });

            this.states[model.cid] = state;
            this.order[options.index] = model.cid;

            row.addStateChangeHandler(_.bind(this.handleStateChange, this));
            row.on('destroy', _.bind(this.updateOrder, this));

            return row;
        },

        updateOrder: function (model) {
            this.order.splice(this.order.indexOf(model.cid), 1);
        },

        itemViewOptions: function (model, index) {
            return {
                state: this.getState(),
                index: index
            }
        },

        getState: function (options) {
            options = options || {};

            return options.state ? options.state : this.options.state;
        },

        handleStateChange: function (state, view, model) {
            var index = this.order.indexOf(model.cid),
                originItemViewOptions = this.itemViewOptions;

            this.closeViewInEditState();

            this.itemViewOptions = function () {
                return {
                    state: state,
                    index: index
                }
            };
            this.removeItemView(model);
            this.addItemView(model, true, index);
            this.itemViewOptions = originItemViewOptions;

            var newView = this.children.find(function (view) {
                    return view.model.cid === model.cid;
                }),
                first = newView.first();

            if (first) {
                first.activate();
            }
        },

        closeViewInEditState: function () {
            var cid, self = this;

            _.find(this.states, function (state, key) {
                if (state === 'edit') {
                    cid = key;
                }
            }, this);

            if (!cid) {
                return;
            }

            this.children.each(function (view) {
                if (view.model.cid === cid) {
                    view.model.set(view.model.previousAttributes(), {silent: true});
                    self.states[view.model.cid] = 'view';
                    view.trigger('change:state', 'view', view, view.model);
                }
            });
        }

    });
});
