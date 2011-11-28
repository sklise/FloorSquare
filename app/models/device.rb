class Device
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :auth_key, APIKey
  property :location, String
  property :device_type_id, Integer

  belongs_to :device_type
end
