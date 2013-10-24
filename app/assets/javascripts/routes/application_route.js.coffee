SeeSpotRun.Router.map ->
  @resource "index", path: "/", ->
    
    @resource "sessions", path: "sessions", ->
      @route "new", {path: "new", queryParams: ["skills_encoded"]}
      @route "session", {path: "/:id", queryParams: ["skills_encoded"]}
      
      
SeeSpotRun.IndexRoute = Em.Route.extend
  # model: -> @store.find("session")
  enter: -> @get("pusher").subscribe("sessions")
  setupController: (controller, model) ->
    controller.set "content", model
    @setupAjax()
    
  setupAjax: ->
    # token = @get("credentials.token")
    $.ajaxSetup
      beforeSend: (xhr, settings) -> 
        # just because the auth_token is a private information
        if settings.crossDomain then return
        # if settings.type is "GET" then return
    
        # xhr.setRequestHeader('X-AUTHENTICATION-TOKEN', token)
      
        csrf_token = $('meta[name="csrf-token"]').attr('content');
        if csrf_token then xhr.setRequestHeader('X-CSRF-Token', csrf_token)
    
  actions:
    session_processed: (data) -> alert data.message
      
    debugme: -> debugger

SeeSpotRun.SessionsIndexRoute = Em.Route.extend
  model: -> @store.find("session")
  setupController: (controller, model) ->
    controller.set "content", model

SeeSpotRun.SessionsSessionRoute = Em.Route.extend
  model: (params) -> @store.find("session", params.id)
  setupController: (controller, model) ->
    controller.set "content", model
  
SeeSpotRun.SessionsNewRoute = Em.Route.extend
  # enter: ->
  #   if @get("controller.content")
  #     Em.run.once @, ->
  #       @replaceWith queryParams: {skills_encoded: @get("controller.skills_encoded")}
    
  model: (params, queryParams) ->  
    # skills = if queryParams["skills_encoded"] then queryParams["skills_encoded"] else "0"
    # return @store.createRecord("session", {skills_encoded: skills}) unless @get("controller.content")
    return @store.createRecord("session", {skills_encoded: "0"}) unless @get("controller.content")
    @get("controller.content")
    
  afterModel: (model, queryParams) ->
    model.decodeSkills()
    
  setupController: (controller, model) ->
    controller.set "content", model