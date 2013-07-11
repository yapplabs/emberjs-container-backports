Container = requireModule('container')

resolverFor = (namespace)->
  resolverClass = namespace.get('resolver') || Ember.DefaultResolver;
  resolver = resolverClass.create
    namespace: namespace
  return (fullName)-> resolver.resolve(fullName)

ContainerSupport = Ember.Mixin.create
  init: ->
    @__container__ = new Container()
    @__container__.resolver = resolverFor(@)
    @__container__.normalize = Ember.String.underscore
    @__container__.optionsForType('template',
      instantiate: false
    )

    @_super()

    @register('application:main', @,  instantiate: false )
    @inject('controller', 'namespace', 'application:main')

  register: ->
    container = @__container__
    container.register.apply(container, arguments)

  inject: ->
    container = @__container__
    container.injection.apply(container, arguments)

ContainerSupport[Ember.GUID_KEY] = 'container_support_application'

unless ContainerSupport.detect(Ember.Application.PrototypeMixin)
  Ember.Application.reopen(ContainerSupport)
