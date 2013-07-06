ContainerSupport = Ember.Mixin.create
  controllerFor: (name)->
    @container.lookup('controller:' + name)
  serviceFor: (name)->
    @container.lookup('service:' + name)

ContainerSupport[Ember.GUID_KEY] = 'container_support_state'

unless ContainerSupport.detect(Ember.State.PrototypeMixin)
  Ember.State.reopen(ContainerSupport)
