StateContainerSupport = Ember.Mixin.create
  controllerFor: (name)->
    @container.lookup('controller:' + name)
  serviceFor: (name)->
    @container.lookup('service:' + name)

StateContainerSupport[Ember.GUID_KEY] = 'container_support_state'

unless StateContainerSupport.detect(Ember.State.PrototypeMixin)
  Ember.State.reopen(StateContainerSupport)
