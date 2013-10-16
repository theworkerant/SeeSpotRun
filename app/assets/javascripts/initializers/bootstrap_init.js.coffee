Ember.Application.initializer
  name: "bootstrap"
 
  initialize: (container, application) ->
    SeeSpotRun.set("settings", Ember.Object.create)
    
    store = container.lookup("store:main")
    
    store.pushMany("skill",window.bootstrap_skills)
    SeeSpotRun.register('controller:app_skills', SeeSpotRun.SkillsController)
    container.lookup("controller:app_skills").set("content",store.all("skill"))
    SeeSpotRun.inject('controller', 'appSkills', 'controller:app_skills')
    
    store.pushMany("condition",window.bootstrap_conditions)
    SeeSpotRun.register('controller:app_conditions', SeeSpotRun.ConditionsController)
    container.lookup("controller:app_conditions").set("content",store.all("condition"))
    SeeSpotRun.inject('controller', 'appConditions', 'controller:app_conditions')

    
    # Stripe.setPublishableKey(window.stripe_publishable)

    # Airbrake.setProject("68298", "4e0c4e3223f0bfb748955f0d5ef8da8a")
    # Airbrake.setEnvironmentName(window.rails_env)
    
    # Google Analytics Init
    # if window.site_url isnt "www.seespotrun.io"
    #   ga('create', window.google_analytics_id, {'cookieDomain': 'none'})
    # else
    #   ga('create', window.google_analytics_id)
      
    # SeeSpotRun.set("isMobile", /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))

