source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use mysql as the database for Active Record
gem 'mysql2'
gem "redis-rails"

gem "delayed_job_active_record"
gem "daemons" # for delayed_job

gem "devise", "3.0.0"
gem "cancan"

gem "stripe"
gem "httparty"
gem "pusher"

gem "active_model_serializers", "~> 0.7.0"

# Image manipulation/storage
gem "carrierwave"
gem "mini_magick"
gem 'fog'

# Use SCSS for stylesheets
gem 'emblem-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'slim'

gem "bitwise"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

group :test, :development do
  gem "rspec-rails"
  gem "guard-rspec"
  gem "capybara"
  gem "factory_girl"
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "capybara-webkit"
  gem "selenium-webdriver"
  gem "timecop"
  gem "teaspoon"
  gem "simplecov"
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
gem 'debugger', group: [:development, :test]
