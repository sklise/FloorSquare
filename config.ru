require 'rubygems'
require './index'
map '/floorsquare' do
  run Sinatra::Application
end
