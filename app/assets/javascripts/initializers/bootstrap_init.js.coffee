Ember.Application.initializer
  name: "bootstrap"
 
  initialize: (container, application) ->
    
    # Skill Mask Mappings
    SeeSpotRun.set("skillsIdMap", window.bootstrap_skills_map)
    SeeSpotRun.set("skillsNameMap", window.boostrap_skills_names)
    empty_mask = ""
    for i in [1..window.bootstrap_skills_map.length]
      empty_mask = empty_mask + "0"
    SeeSpotRun.set("emptySkillsMask", empty_mask)
    
    # Condition Mask Mappings
    SeeSpotRun.set("conditionsIdMap", window.bootstrap_conditions_map)
    SeeSpotRun.set("conditionsNameMap", window.bootstrap_conditions_names)
    empty_mask = ""
    for i in [1..window.bootstrap_conditions_map.length]
      empty_mask = empty_mask + "0"
    SeeSpotRun.set("emptyConditionsMask", empty_mask)

    # Bootstrap & inject store data
    store = container.lookup("store:main")
    
    store.pushMany("skill",window.bootstrap_skills)
    SeeSpotRun.register("controller:app_skills", SeeSpotRun.SkillsController)
    container.lookup("controller:app_skills").set("content",store.all("skill"))
    SeeSpotRun.inject("controller", "appSkills", "controller:app_skills")
    
    store.pushMany("condition",window.bootstrap_conditions)
    SeeSpotRun.register("controller:app_conditions", SeeSpotRun.ConditionsController)
    container.lookup("controller:app_conditions").set("content",store.all("condition"))
    SeeSpotRun.inject("controller", "appConditions", "controller:app_conditions")

    
    # Stripe.setPublishableKey(window.stripe_publishable)

    # Airbrake.setProject("68298", "4e0c4e3223f0bfb748955f0d5ef8da8a")
    # Airbrake.setEnvironmentName(window.rails_env)
    
    # Google Analytics Init
    # if window.site_url isnt "www.seespotrun.io"
    #   ga("create", window.google_analytics_id, {"cookieDomain": "none"})
    # else
    #   ga("create", window.google_analytics_id)
      
    # SeeSpotRun.set("isMobile", /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent))

