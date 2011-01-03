class IconsController < ApplicationController
  before_filter do
    session.instance_variable_set :@user, User.new
    
    params[:theme_id] ||= 1 if params[:default]
    
    @theme = Theme[params[:theme_id]] if params[:theme_id]
    @app = App[params[:app_id]] if params[:app_id]
  end
  
  def index
    @icons = Icon.live
    
    @theme = Theme[1] if @theme.full?{|b| b.pk == 3}
    
    @icons.filter!(:theme_id => @theme.pk) if @theme
    @icons.filter!(:app_id => @app.pk) if @app
    
    @icons.limit!(*pager_params)
    
    with_vals = []
    with_vals |= params[:with] if params[:with]
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @icons.all, :with => with_vals }
    end
  end
  
  def new
    @icon = Icon.new
    @icon.theme_id = @theme.pk if @theme
    @app.app_id = @app.pk if @app
    @icon.state = 'pending'
    @icons = [@icon]*1
  end
  
  def create
    @icons = params[:icons].collect {|num,i| Icon.new(i)}
    
    @icons.each {|i| i.state = 'pending'} unless session.user.is_admin?
    # debugger
    if @icons.select {|i| !i.save }.empty?
      redirect_to theme_icons_path(@theme)
    else
      render(:new)
    end
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
