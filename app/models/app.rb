class App < Sequel::Model
  plugin :timestamps
  one_to_many :icons
  one_to_many :icon_requests
  one_to_many :icon_request_counts
  one_to_many :app_uniq_names, :as => :uniq_names
end
