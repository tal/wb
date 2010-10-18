class Icon < Sequel::Model
  BUCKET = Rails.env?('production') ? 'icons.wbthemes.com' : 'dev.icons.wbthemes.com'
  plugin :timestamps
  
  many_to_one :app
  many_to_one :theme
  
  subset :live, :state => 'live'
  subset :pending, :state => 'pending'
  
  attr_accessor :file
  
  def after_initialize
    super
    
    self.asset_code ||= new_code
  end
  
  def before_save
    process_file if @file
    
    super
  end
  
  def filename
    "icon-#{asset_code}.png"
  end
  
  def url
    "http://#{BUCKET}/#{filename}"
  end
  
  def process_file
    OldIconImage.create(:asset_code => asset_code, :icon_id => pk) if asset_code && pk
    self.asset_code = new_code
    store_file
  end
  
  def new_code
    UUIDTools::UUID.random_create().to_s.gsub('-','')
  end
  
  def store_file
    S3Icon.store(filename,@file,:access => :public_read)
  end
end

class S3Icon < AWS::S3::S3Object
  set_current_bucket_to Icon::BUCKET
end
