window.attr      = DS.attr
window.belongsTo = DS.belongsTo
window.hasMany   = DS.hasMany

String.prototype.replaceAt = (index, character) ->
  return @substr(0, index) + character + @substr(index+character.length)

DS.rejectionHandler = (reason) ->
  if (reason.status is 401)
    App.Auth.destroy()
  throw reason

Ember.FEATURES["query-params"] = true
window.SeeSpotRun = Ember.Application.create
  rootElement: '#ember-app'
