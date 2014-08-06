define(['rivets', 'marionette'], function (rivets, Marionette) {
    'use strict';

    rivets.configure({
        adapter: {
            subscribe: function (obj, keypath, callback) {
                obj.on('change:' + keypath, callback);
            },

            unsubscribe: function (obj, keypath, callback) {
                obj.off('change:' + keypath, callback);
            },

            read: function (obj, keypath) {
                return obj.get(keypath);
            },

            publish: function (obj, keypath, value) {
                obj.set(keypath, value);
            }
        }
    });

    var originViewConstructor = Marionette.View.prototype.constructor;

    Marionette.View.prototype.constructor = function () {
        this.binding = this.binding || false;

        var bindModel = function () {
                rivets.bind(this.$el, {
                    view: this,
                    model: this.model ? this.model.toJSON() : {}
                });
            },
            unbindModel = function () {
                rivets.unbind(this.$el);
            };

        this.binding
        && this.listenTo(this, 'render', bindModel, this)
        && this.listenTo(this, 'close', unbindModel, this);

        originViewConstructor.apply(this, arguments);
    };

});