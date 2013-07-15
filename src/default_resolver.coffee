if !Ember.String.capitalize
  Ember.String.capitalize = (str)->
    str.charAt(0).toUpperCase() + str.substr(1)

get = Ember.get
classify = Ember.String.classify
capitalize = Ember.String.capitalize
decamelize = Ember.String.decamelize

Ember.DefaultResolver ?= Ember.Object.extend(
  namespace: null

  resolve: (fullName) ->
    parsedName = @parseName(fullName)
    typeSpecificResolveMethod = this[parsedName.resolveMethodName]
    if typeSpecificResolveMethod
      resolved = typeSpecificResolveMethod.call(this, parsedName)
      return resolved  if resolved
    @resolveOther parsedName

  parseName: (fullName) ->
    nameParts = fullName.split(":")
    type = nameParts[0]
    fullNameWithoutType = nameParts[1]
    name = fullNameWithoutType
    namespace = get(this, "namespace")
    root = namespace
    if type isnt "template" and name.indexOf("/") isnt -1
      parts = name.split("/")
      name = parts[parts.length - 1]
      namespaceName = capitalize(parts.slice(0, -1).join("."))
      root = Ember.Namespace.byName(namespaceName)
      Ember.assert "You are looking for a " + name + " " + type + " in the " + namespaceName + " namespace, but the namespace could not be found", root
    fullName: fullName
    type: type
    fullNameWithoutType: fullNameWithoutType
    name: name
    root: root
    resolveMethodName: "resolve" + classify(type)

  resolveTemplate: (parsedName) ->
    templateName = parsedName.fullNameWithoutType.replace(/\./g, "/")
    return Ember.TEMPLATES[templateName]  if Ember.TEMPLATES[templateName]
    templateName = decamelize(templateName)
    Ember.TEMPLATES[templateName]  if Ember.TEMPLATES[templateName]

  useRouterNaming: (parsedName) ->
    parsedName.name = parsedName.name.replace(/\./g, "_")
    parsedName.name = ""  if parsedName.name is "basic"

  resolveController: (parsedName) ->
    @useRouterNaming parsedName
    @resolveOther parsedName

  resolveRoute: (parsedName) ->
    @useRouterNaming parsedName
    @resolveOther parsedName

  resolveView: (parsedName) ->
    @useRouterNaming parsedName
    @resolveOther parsedName

  resolveOther: (parsedName) ->
    className = classify(parsedName.name) + classify(parsedName.type)
    factory = get(parsedName.root, className)
    factory  if factory
)
