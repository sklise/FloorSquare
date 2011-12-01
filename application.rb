require 'bundler'
Bundler.require
# require 'active_record'

configure do |c|
  enable :sessions
  set :root, File.dirname(__FILE__)
  set :views, Proc.new{ File.join(root, "views")}
  set :scss, :style => :compact

  disable :protection

  set :allow_origin, :any
  set :database, 'sqlite://development.sqlite'
end

require './models'
require './helpers'
require './routes'