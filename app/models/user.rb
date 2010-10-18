class User < Sequel::Model
  plugin :timestamps
  
  one_to_many :icons
  one_to_many :icon_requests
  
  def is_admin?
    true
  end
end
