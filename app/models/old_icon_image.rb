class OldIconImage < Sequel::Model
  plugin :timestamps, :update => false
  unrestrict_primary_key
end