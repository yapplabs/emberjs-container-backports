ContainerSupport = Ember.Mixin.create
  createChildView: (view, attrs)->
    if Ember.CoreView.detect(view)
      attrs ||= {}
      attrs.container = @container
      @_super(view, attrs)
    else
      view.container ||= @container
      @_super(view)

ContainerSupport[Ember.GUID_KEY] = 'container_support_view'

unless ContainerSupport.detect(Ember.View.PrototypeMixin)
  Ember.View.reopen(ContainerSupport)
