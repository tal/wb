class Theme < Sequel::Model
  plugin :timestamps
  
  one_to_many :icons
  one_to_many :icon_requests
  one_to_many :icon_request_counts
end
