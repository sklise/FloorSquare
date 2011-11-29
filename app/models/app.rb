class App
  include DataMapper::Resource

  property :id,     Serial, :key => true
  property :auth_key, APIKey
  property :email,  String
  property :url,    String

  has n, :swipes
end
