class IconRequest < Sequel::Model
  unrestrict_primary_key
  plugin :timestamps, :update => false
  many_to_one :user
  many_to_one :theme
  many_to_one :app
  many_to_one :icon_request_count, :key=>[:theme_id,:app_id]
  
  def after_create
    super
    
    if cnt = IconRequestCount.find_or_create(:theme_id => theme_id, :app_id => app_id)
      cnt.update(:count => count.count+1)
    end
  end
  
  def after_destroy
    super
    
    icon_request_count_dataset.update(:count => :count - 1)
  end
  
end
