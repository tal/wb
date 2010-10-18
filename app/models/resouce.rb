class Resouce < Sequel::Model
  plugin :timestamps
  
  many_to_one :theme
end
