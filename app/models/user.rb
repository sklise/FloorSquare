class User
  include DataMapper::Resource

  property :nnumber,    Integer, :key => true
  property :netid,      String   
  property :created_at, DateTime  
  property :name,       String  
  property :photo,      String  
  property :extra,      Json,  :lazy=> false

  has n, :swipes
end
