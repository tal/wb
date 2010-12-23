class TemplateController < ApplicationController
  
  def all
    dir = "app/templates/**/"
    files = Dir[dir+"*.mustache"]
    partials = Dir[dir+"_*.mustache"]
    templates = files-partials
    
    obj = {}
    templates.each do |t|
      tt = File.open(t).read
      fname = t.gsub('app/templates/','').gsub('.html','').gsub('.mustache','')
      dirname,fname = fname.split('/')
      
      (obj[dirname]||={:partials =>{}})[fname] = tt
    end
    
    partials.each do |t|
      tt = File.open(t).read
      fname = t.gsub('app/templates/','').gsub('.html','').gsub('.mustache','')
      dirname,fname = fname.split('/')
      
      fname.gsub!(/^_/,'')
      
      (obj[dirname]||={:partials =>{}})[:partials][fname] = tt
    end
    
    # render :json => obj
    
    ret = 'WB={};WB.t = '+obj.to_json+';'
    render :text => ret
  end
  
  def show
    dir = "app/templates/#{params[:template]}/"
    files = Dir[dir+"*.mustache"]
    partials = Dir[dir+"_*.mustache"]
    templates = files-partials
    
    obj = {:partials => {}}
    templates.each do |t|
      tt = File.open(t).read
      fname = t.gsub(dir,'').gsub('.html','').gsub('.mustache','')
      
      obj[fname] = tt
    end
    
    partials.each do |t|
      tt = File.open(t).read
      fname = t.gsub(dir,'').gsub('.html','').gsub('.mustache','')
      
      obj[:partials][fname] = tt
    end
    
    render :json => obj
  end
  
end
