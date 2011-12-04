class User < ActiveRecord::Base
  has_many :swipes
end

class App  < ActiveRecord::Base
  before_save :ensure_auth_key
  validates_uniqueness_of :auth_key
  has_many :swipes

  private
    def ensure_auth_key
      self.auth_key ||= SecureRandom.hex
    end
end

class Swipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :app
end

class Device < ActiveRecord::Base
  before_save :ensure_auth_key
  validates_uniqueness_of :auth_key
  belongs_to :device_type

  private
    def ensure_auth_key
      self.auth_key ||= SecureRandom.hex
    end
end

class DeviceType  < ActiveRecord::Base
  has_many :devices
end