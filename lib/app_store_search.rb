require 'yajl/gzip'
require 'yajl/deflate'
require 'yajl/http_stream'

module AppStoreSearch
  class GoogleResult
    def initialize(args)
      @args = args
    end
    
    def title(formatted = true)
      formatted ? @args[:title] : @args[:titleNoFormatting]
    end
    
    def url
      @args[:unescapedUrl]
    end
    
    def content
      @args[:content]
    end
    
    def app
      @app ||= App.new(url)
    end
    
    def inspect
      %Q{#<AppStoreSearch::Result #{title(false)}>}
    end
    
  end
  
  class App
    attr_reader :url
    def initialize(url)
      @url = url
      
      @doc = Hpricot(open(@url))
    end
    
    def inspect
      arr = [:name].inject([]) do |result, att|
        result << "#{att}: #{__send__(att).inspect}"
        result
      end
      
      %Q{#<AppStoreSearch::App #{arr.join(' ')}>}
    end
    
    def icon_url
      @icon_url ||= left_stack.search('img.artwork').attr('src')
    end
    
    # Returns opened file object for the icon image
    def icon_image
      @icon ||= open(icon_url)
    end
    
    def new_icon
      Icon.new(:theme_id => Icon::DEFAULT_THEME_ID, :file => icon_image, :size => '175')
    end
    
    def name
      @name ||= title.search('h1').inner_html
    end
    
    def author
      @author ||= title.search('h2').inner_html.try(:gsub,/^by\s+/i,'')
    end
    
    def description
      @description ||= @doc.search('div.center-stack p.truncate').inner_html
    end
    
    def price
      @price ||= list.search('div.price').inner_html
    end
    
    def app_url
      @app_url ||= @doc.search('div.app-links a.see-all').first.try(:get_attribute,'href')
    end
    
    # Returns a values hash for use with an App model
    def get_app_values
      {:name => name, :store_url => url, :url => app_url, :app_store_app => self}
    end
    
    def new_app
      ::App.new(get_app_values)
    end
    
  private
    
    def title
      @title ||= @doc.search('#title')
    end
    
    def left_stack
      @left_stack ||= @doc.search('#left-stack')
    end
    
    def list
      @list ||= left_stack.search('ul.list')
    end
    
  end
  
end

module AppStoreSearch
  extend self
  
  def search app_name, args = {}
    url = URL.new('http://ajax.googleapis.com/ajax/services/search/web?v=1.0')
    url.params[:q] = "site:http://itunes.apple.com/us/app/ #{app_name}"
    hash = {:results => []}
    Yajl::HttpStream.get(url.to_uri, :symbolize_keys => true) do |h|
      hash = h
    end
  
    google_results = hash[:responseData][:results].collect do |r|
      AppStoreSearch::GoogleResult.new(r)
    end
  
    return google_results.first.try(:app) if args[:first]
  
    google_results[0...(args[:results]||3)].collect do |g|
      g.app
    end
  end
  
  def with_apps app_name, args={}
    results = search(app_name, :results => args[:results]||5)
    
    results.collect do |app|
      next unless app.name.present?
      ::App[:name => app.name] || app.new_app.save
    end.compact
  end
  
end

def AppStoreSearch *args
  AppStoreSearch.search(*args)
end
