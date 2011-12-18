class User < ActiveRecord::Base
  # A User owns many swipes, declare this association to
  # allow calls to `User.find(1).swipes` which returns an
  # array of associated swipes.
  has_many :swipes
  # The `extra` field is JSON which needs to be serialized
  # to save in the database.
  serialize :extra

  # Define a method to return the url for photos based on netid.
  def photo
    "http://itp.nyu.edu/image.php?width=260&height=260&cropratio=1:1&image=/people_pics/itppics/#{netid}.jpg"
  end
end

class App  < ActiveRecord::Base
  # Create an auth_key if non specified before save
  before_save :ensure_auth_key
  # Be absolutely certain that the 16 character hex
  # auth_key value is unique.
  validates_uniqueness_of :auth_key
  has_many :swipes
  has_one :user

  private
    def ensure_auth_key
      self.auth_key ||= SecureRandom.hex
    end
end

class Swipe < ActiveRecord::Base
  belongs_to :user
  belongs_to :app
  # The `extra` field is JSON which needs to be serialized
  # to save in the database.
  serialize :extra

  def time
    self.created_at.getlocal("-05:00").strftime("%d %a %H:%M")
  end
end

class Device < ActiveRecord::Base
  # Create an auth_key if non specified before save
  before_save :ensure_auth_key
  # Be absolutely certain that the 16 character hex
  # auth_key value is unique.
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