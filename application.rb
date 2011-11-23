require 'bundler'
Bundler.require
require 'active_record'
configure do |c|
  enable :sessions
  set :root, File.dirname(__FILE__)
  set :views, Proc.new{ File.join(root, "app/views")}
  set :scss, :style => :compact
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'development.sqlite.db'
)

Dir['./app/*/*.rb'].each {|file| require file}
