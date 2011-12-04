require 'rubygems'
require './application'
map '/floorsquare' do
  run Sinatra::Application
end