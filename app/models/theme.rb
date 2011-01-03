class Theme < Sequel::Model
  plugin :timestamps
  
  one_to_many :icons
  one_to_many :icon_requests
  one_to_many :icon_request_counts
  
  def as_json(args={})
    hsh = {
      :values => values,
      :name => name,
      :id => pk
    }
    
    if args
      hsh[:icons] = icons if args[:icons]
    end
    
    hsh
  end
end
