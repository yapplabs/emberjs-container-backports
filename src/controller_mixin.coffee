ContainerControllerProxy = Ember.Object.extend
  unknownProperty: (name)->
    name = name.replace(/Controller$/,'')
    @container.lookup('controller:' + name)

ContainerSupport = Ember.Mixin.create
  controllers: Ember.computed ->
    ContainerControllerProxy.create
      container: @container
  createOutletView: (outletName, viewClass)->
    viewClass.create
      container: @container

ContainerSupport[Ember.GUID_KEY] = 'container_support_controller_mixin'

unless ContainerSupport.detect(Ember.ControllerMixin.PrototypeMixin)
  Ember.ControllerMixin.reopen(ContainerSupport)
