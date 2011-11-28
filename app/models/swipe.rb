# require 'dm-core'
# require 'dm-migrations'

# DataMapper.setup(:default, ENV['DATABASE_URL'] || 'sqlite:///Users/zach/Fall_2012_ITP/Networks/UnderstandingNetworksFall2011/db_dev.sqlite')


class Swipe #< DataMapper::Base
  include DataMapper::Resource

  property :id,         Serial  
  property :netid,      String  
  property :credential, String  
  property :timestamp, 	DateTime
  property :device_id, 	Integer  
  property :app_id,     Integer
  property :extra,      Json, :lazy=> false

end