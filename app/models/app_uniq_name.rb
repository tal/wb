class AppUniqName < Sequel::Model
  unrestrict_primary_key
  plugin :timestamps, :update => false
  many_to_one :app
end