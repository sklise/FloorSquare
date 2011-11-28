class App
  include DataMapper::Resource

  property :id,     Serial, :key => true
  property :email,  String
  property :url,    String
  property :auth_key, APIKey

  has n, :swipes
end
