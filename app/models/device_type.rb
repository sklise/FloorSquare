class DeviceType
  include DataMapper::Resource

  property :id,           Serial, :key => true
  property :name,         String
  property :description,  Text

  has n, :devices
end