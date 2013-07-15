ContainerControllerProxy = Ember.Object.extend
  unknownProperty: (name)->
    name = name.replace(/Controller$/,'')
    @container.lookup('controller:' + name)

ControllerContainerSupport = Ember.Mixin.create
  container: null
  controllers: Ember.computed ->
    ContainerControllerProxy.create
      container: @container
  createOutletView: (outletName, viewClass)->
    viewClass.create
      container: @container

ControllerContainerSupport[Ember.GUID_KEY] = 'container_support_controller_mixin'

unless ControllerContainerSupport.detect(Ember.ControllerMixin.PrototypeMixin)
  Ember.ControllerMixin.reopen(ControllerContainerSupport)

Ember.ObjectProxy.reopen
  _debugContainerKey: null
