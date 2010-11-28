class Icon < Sequel::Model
  BUCKET = Rails.env.production? ? 'icons.wbthemes.com' : 'dev.icons.wbthemes.com'
  DEFAULT_THEME_ID = 1
  plugin :timestamps
  
  many_to_one :app
  many_to_one :theme
  
  subset :live, :state => 'live'
  subset :pending, :state => 'pending'
  subset :default, :theme_id => DEFAULT_THEME_ID
  
  attr_accessor :file
  attr_reader :file_uploaded
  forward_method :app, :name, :uniq_name
  
  def validate
    super
    
    validates_relation :app_id, :theme_id
    errors.add(:file, 'needs to have an image to upload') if new? && !@file
    process_file if @file
  end
  
  def after_initialize
    super
    
    self.asset_code ||= new_code
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
    UUIDTools::UUID.random_create.to_s.gsub('-','')
  end
  
  def store_file
    return unless @file
    i = S3Icon.store(filename,@file,:access => :public_read)
    @file = nil
    @file_uploaded = true
    i
  end
end

class S3Icon < AWS::S3::S3Object
  set_current_bucket_to Icon::BUCKET
end
