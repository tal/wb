class IconRequestCount < Sequel::Model
  unrestrict_primary_key
  plugin :timestamps
  many_to_one :theme
  many_to_one :app
  one_to_many :icon_requests, :key => [:theme_id,:app_id]
end