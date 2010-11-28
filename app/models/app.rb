class App < Sequel::Model
  plugin :timestamps
  one_to_many :icons
  one_to_many :icon_requests
  one_to_many :icon_request_counts
  
  attr_accessor :app_store_app
  
  def after_create
    super
    
    if @app_store_app.try(:icon_image)
      icon = @app_store_app.new_icon
      icon.app_id = pk
      icon.save
    end
  end
  
  def default_icon
    icons_dataset.default.first
  end
  
  def image
    default_icon.try(:url) || 'http://dummyimage.com/49.png'
  end
  
  def as_json(*args)
    super(*args).merge(:image => image)
  end
  
  def self.find_or_initialize_by_name(name)
    app = App[:name => name]
    return app if app
    
    a = AppStoreSearch(name, :first => true)
    
    return App.new(:name => name) unless a
    
    App[:name => a.name] || App.new(a.get_app_values)
  end
  
end
