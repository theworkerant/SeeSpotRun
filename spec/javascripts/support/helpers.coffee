window.lookupStore  = -> SeeSpotRun.__container__.lookup 'store:main'
window.lookupRouter = -> SeeSpotRun.__container__.lookup 'router:main'

window.modifyEmptyMask = (append, type) ->
  empty         = SeeSpotRun.get("empty#{type}sMask")
  "#{empty.substr(0,empty.length-append.length)}#{append}"      
  
window.setupSession = (skills_encoded) ->
  Em.run ->
    T.SomeModel = DS.Model.extend SeeSpotRun.SkillsMixin,
      store: T.store
      skills_encoded: skills_encoded
  
  someModel = new T.SomeModel
  Em.run -> someModel .trigger("didLoad")
  someModel
  
window.setupSkill = ->
  Em.run ->
    T.SomeModel = DS.Model.extend SeeSpotRun.ConditionsMixin,
      store: T.store
    
  someModel = new T.SomeModel  