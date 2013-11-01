set = Ember.set
get = Ember.get
forEach = Ember.EnumerableUtils.forEach

ViewContainerSupport = Ember.Mixin.create
  createChildView: (view, attrs)->
    if Ember.CoreView.detect(view)
      attrs ||= {}
      attrs.container = @container
      @_super(view, attrs)
    else
      view.container ||= @container
      @_super(view)
  templateForName: (name, type) ->
    return unless name
    this.container.lookup('template:' + name)

ViewContainerSupport[Ember.GUID_KEY] = 'container_support_view'

Ember.View.reopen(ViewContainerSupport)

Ember.ContainerView.reopen
  initializeViews: (views, parentView, templateData)->
    forEach views, (view)->
      set(view, '_parentView', parentView)
      if (!view.container && parentView && parentView.container)
        set(view, 'container', parentView && parentView.container)
      unless get(view, 'templateData')
        set(view, 'templateData', templateData)
