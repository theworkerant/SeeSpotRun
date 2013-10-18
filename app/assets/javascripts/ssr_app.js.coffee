window.attr      = DS.attr
window.belongsTo = DS.belongsTo
window.hasMany   = DS.hasMany
window.parseConditionsMask = (int) ->
  int     = parseInt(int) if typeof int is "string"
  string  = int.toString(2)
  size    = SeeSpotRun.get("emptyConditionsMask").length
  string  = string.substring(0,size)
  while string.length < size
    string = "0" + string
  string
window.parseSkillsMask = (int) ->
  int     = parseInt(int) if typeof int is "string"
  string  = int.toString(2)
  size    = SeeSpotRun.get("emptySkillsMask").length
  string  = string.substring(0,size )
  while string.length < size
    string = "0" + string
  string

String.prototype.replaceAt = (index, character) ->
  return @substr(0, index) + character + @substr(index+character.length)

DS.rejectionHandler = (reason) ->
  if (reason.status is 401)
    App.Auth.destroy()
  throw reason

window.SeeSpotRun = Ember.Application.create
  rootElement: '#ember-app'
