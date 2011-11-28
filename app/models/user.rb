# class User < DataMapper::Base
#   property :id, Serial, :key => true
# end


class User #< DataMapper::Base
  include DataMapper::Resource

  property :netid,      String , :key => true   
  property :created_at, DateTime  
  property :name,		String  
  property :photo,		String  
  property :extra, 		Json,  :lazy=> false
end
