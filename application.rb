require 'bundler'
Bundler.require

# require 'sinatra'
# require 'sinatra/cross_origin'


configure do |c|
  enable :sessions
  set :root, File.dirname(__FILE__)
  set :views, Proc.new{ File.join(root, "app/views")}
  set :scss, :style => :compact
  
  disable :protection

  set :allow_origin, :any


end

# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:///Users/sklise/ITP/floorsquare/db_dev.sqlite')
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:///Users/zach/Fall_2012_ITP/Networks/UnderstandingNetworksFall2011/
db_dev.sqlite')

Dir['./app/*/*.rb'].each {|file| require file}