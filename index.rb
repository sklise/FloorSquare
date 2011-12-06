# This is the main file of the Floorsquare Sinatra App.
# The app is launched through Rack based on the settings
# in `config.ru` which requires this file.

# Start by requiring Bundler to load all the gems
# as indicated in `Gemfile`.
require 'bundler'
Bundler.require

# Sinatra configuration settings. Initiate sessions
# and tell Sinatra where the files are. 
configure do |c|
  enable :sessions
  set :root, File.dirname(__FILE__)
  set :views, Proc.new{ File.join(root, "views")}
  set :scss, :style => :compact

  # Set the database connection such that when deployed to
  # Heroku the connection is made with `ENV['DATABASE_URL']`
  # and when `ENV` is not defined to default to a local
  # sqlite database.
  set :database, ENV['DATABASE_URL'] || 'sqlite://development.sqlite'

  # Enable cross browser JSON and setup ActiveRecord to exclude
  # root in JSON.
  disable :protection
  set :allow_origin, :any
  ActiveRecord::Base.include_root_in_json = false
end

# The models for this app are defined in [models.rb](models.html)
require './models'
# Helper functions are defined in [helpers.rb](helpers.html)
require './helpers'
# Finally, all routes are defined in [routes.rb](routes.html)
require './routes'