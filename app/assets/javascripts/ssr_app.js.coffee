window.attr      = DS.attr
window.belongsTo = DS.belongsTo
window.hasMany   = DS.hasMany

DS.rejectionHandler = (reason) ->
  if (reason.status is 401)
    App.Auth.destroy()
  throw reason

window.SeeSpotRun = Ember.Application.create
  rootElement: '#ember-app'
