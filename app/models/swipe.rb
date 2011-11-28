class Swipe
  include DataMapper::Resource

  property :id,           Serial, :key => true
  property :user_nnumber, Integer
  property :nnumber,      Integer
  property :netid,        String  
  property :credential,   String  
  property :created_at,   DateTime
  property :device_id,    Integer
  property :app_id,       Integer
  property :extra,        Json, :lazy=> false

  belongs_to :user
end