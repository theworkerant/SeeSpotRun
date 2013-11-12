require "game/modifiers"
require "game/stats"

module Game
  extend ActiveSupport::Concern
  
  include Game::Modifiers
  include Game::Stats
end