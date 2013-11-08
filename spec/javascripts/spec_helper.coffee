# = require lib/jquery-2.0.0
# = require lib/jquery.cookie
# = require lib/moment.min
# = require lib/progress_bar
# = require lib/bootstrap
# = require lib/bignumber
# = require lib/bitmask
# = require lib/uuid

# Normally loaded via DOM
# = require support/pusher

# EMBER
# = require lib/handlebars-1.0.0
# = require lib/ember
# = require lib/ember-data

# = require_tree ../../app/assets/javascripts/templates

# = require support/bootstrap
# = require_tree ./fixtures

# = require support/ember_test_app

# = require lib/pusher

# = require_tree ../../app/assets/javascripts/routes
# = require_tree ../../app/assets/javascripts/mixins
# = require_tree ../../app/assets/javascripts/models
# = require_tree ../../app/assets/javascripts/controllers
# = require_tree ../../app/assets/javascripts/initializers
# = require_tree ../../app/assets/javascripts/components
# = require_tree ../../app/assets/javascripts/helpers
# = require_tree ../../app/assets/javascripts/views

# = require support/chai
# = require support/chai-jquery
window.expect = chai.expect

# This hook defers the readiness of the application, so that you can start 
# the app when your tests are ready to run. It also sets the router's location
# to 'none', so that the window's location will not be modified (preventing 
# both accidental leaking of state between tests and interference with your testing framework).
SeeSpotRun.setupForTesting()

# visit(url)
# Visits the given route and returns a promise that fulfills when all resulting async behavior is complete.

# find(selector, context)
# Finds an element within the app's root element and within the context (optional). Scoping to the root element is especially useful to avoid conflicts with the test framework's reporter.

# fillIn(input_selector, text)
# Fills in the selected input with the given text and returns a promise that fulfills when all resulting async behavior is complete.

# click(selector)
# Clicks an element and triggers any actions triggered by the element's click event and returns a promise that fulfills when all resulting async behavior is complete.

# keyEvent(selector, type, keyCode)
# Simulates a key event type, e.g. keypress, keydown, keyup with the desired keyCode on element found by the selector.

# wait()
# Returns a promise that fulfills when all async behavior is complete.
SeeSpotRun.injectTestHelpers()

window.lookupStore  = -> SeeSpotRun.__container__.lookup 'store:main'
window.lookupRouter = -> SeeSpotRun.__container__.lookup 'router:main'

$("body").attr("style", "> .ember-view {display:none;}")

beforeEach (done) ->  
  # reset all test variables!
  window.Test = {}
  window.T    = Test
  
  Ember.run ->
    SeeSpotRun.advanceReadiness()
    SeeSpotRun.then -> 
      T.store   = lookupStore()
      T.router  = lookupRouter()
      done() # When App readiness promise resolves, setup is complete  
    
afterEach ->
  Em.run -> SeeSpotRun.reset()