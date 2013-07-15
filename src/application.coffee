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

  setupRouter: (router)->
    if !router && Ember.Router.detect(@Router)
      router = @__container__.lookup('router:main')
      @_createdRouter = router

    if router
      set(@, 'router', router)
      set(router, 'namespace', @)

    router

  createApplicationView: (router)->
    rootElement = get(@, 'rootElement')
    applicationViewOptions = {}
    applicationViewClass = @ApplicationView
    applicationTemplate = router.container.lookup('template:application')  # was Ember.TEMPLATES.application

    # don't do anything unless there is an ApplicationView or application template
    return if (!applicationViewClass && !applicationTemplate)

    if router
      applicationController = router.container.lookup('controller:application')
      if applicationController
        applicationViewOptions.controller = applicationController

    if applicationTemplate
      applicationViewOptions.template = applicationTemplate

    if !applicationViewClass
      applicationViewClass = Ember.View

    applicationView = applicationViewClass.create(applicationViewOptions)

    this._createdApplicationView = applicationView

    if router
      set(router, 'applicationView', applicationView)

    applicationView.appendTo(rootElement)


ContainerSupport[Ember.GUID_KEY] = 'container_support_application'

unless ContainerSupport.detect(Ember.Application.PrototypeMixin)
  Ember.Application.reopen(ContainerSupport)
