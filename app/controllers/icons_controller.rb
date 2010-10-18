class IconsController < ApplicationController
  before_filter do
    session.instance_variable_set :@user, User.new
  end
  
  def index
    @icons = Icon.live
    
    if params[:theme_id]
      @icons.filter!(:theme_id => params[:theme_id]) if params[:theme_id]
      @theme = Theme[params[:theme_id]]
    elsif params[:app_id]
      @icons.filter!(:app_id => params[:app_id])
      @app = App[params[:app_id]]
    end
    
    @icons.limit!(*pager_params)
  end
  
  def new
    @icon = Icon.new
    @icon.state = 'pending'
  end
  
  def create
    @icon = Icon.new(params[:icon])
    @icon.state = 'pending' unless session.user.is_admin?
    @icon.save
    
    redirect_to @icon
  end
  
  def destroy
    @icon = Icon.live.filter(:id => params[:id]).first
    
    if @icon && (session.user_id == @icon.user_id || session.user.is_admin?)
      # @icon.destroy
      @icon.state = 'removed'
      @icon.save
    end
  end
  
end
