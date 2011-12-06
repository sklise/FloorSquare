require 'bundler'
Bundler.require

configure do |c|
  enable :sessions
  set :root, File.dirname(__FILE__)
  set :views, Proc.new{ File.join(root, "views")}
  set :scss, :style => :compact

  disable :protection
  set :allow_origin, :any
  ActiveRecord::Base.include_root_in_json = false
  set :database, ENV['DATABASE_URL'] || 'sqlite://development.sqlite'
end

require './models'
require './helpers'
require './routes'