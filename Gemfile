source 'https://rubygems.org'

# Be sure to include rake in your gemfile
gem 'rake'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'

# Use mysql as the database for Active Record
#gem 'mysql2'

# Use Postgre for the DB
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Add Bootstrap, this relies on sass-rails
gem 'bootstrap-sass', '~> 3.1.1'
gem 'twitter-typeahead-rails'
gem 'bootstrap-datepicker-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

group :development do
	gem 'rails_layout'
end

# New model gem for increased security
gem 'devise'
gem 'bcrypt'

#Better forming
gem 'simple_form'

#Fix to Active-Admin
gem "formtastic", github: "justinfrench/formtastic"

#Inline editing of Twitter Bootsrap
gem 'bootstrap-x-editable-rails'

#For whois searching
gem 'robowhois'

#Adding activeadmin so that it can be used as a backend
gem 'activeadmin', github: 'gregbell/active_admin'


# For Deployment
gem 'capistrano', '~> 3.1.0', require: false, group: :development
gem 'rvm1-capistrano3', require: false

group :development do
gem 'capistrano-rails',   '~> 1.1', require: false
gem 'capistrano-bundler', '~> 1.1', require: false
end

# Use the Unicorn app server
gem 'unicorn'