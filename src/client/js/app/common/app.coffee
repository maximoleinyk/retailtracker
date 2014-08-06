define ['marionette', 'cs!app/common/view/layout/top'], (Marionette, Layout) ->
  Marionette.Renderer.render = (compile, data) ->
    compile data

  new Layout().render()
  new Marionette.Application
