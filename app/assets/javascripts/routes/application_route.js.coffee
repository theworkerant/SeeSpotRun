SeeSpotRun.Router.map ->
  @route "index", path: "/"
  
SeeSpotRun.IndexRoute = Em.Route.extend
  model: -> @store.find("session")
  setupController: (controller, model) ->
    controller.set "content", model
    
  actions:
    debugme: -> debugger
  