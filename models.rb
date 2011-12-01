class User < ActiveRecord::Base
  has_many :swipes
end

class App  < ActiveRecord::Base
  validates_uniqueness_of :auth_key
  has_many :swipes
end

class Swipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :app
end

class Device < ActiveRecord::Base
  validates_uniqueness_of :auth_key
  belongs_to :device_type
end

class DeviceType  < ActiveRecord::Base
  has_many :devices
end