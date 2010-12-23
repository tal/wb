class AppsController < ApplicationController
  # GET /apps
  # GET /apps.json
  def index
    if params[:from_app_store]
      @apps = AppStoreSearch.with_apps(params[:filter])
    else
      @apps = App.dataset
      
      if params[:filter]
        like = "#{params[:filter].downcase}%"
        @apps.filter!{ ucase(name).like(ucase(like)) }
      end
      
      @apps = @apps.limit!(*pager_params).all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @apps }
    end
  end

  # GET /apps/1
  # GET /apps/1.xml
  def show
    @app = App.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @app }
      format.json { render :json => @app }
    end
  end

  # GET /apps/new
  # GET /apps/new.xml
  def new
    @app = App.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @app }
    end
  end

  # GET /apps/1/edit
  def edit
    @app = App.get(params[:id])
  end

  # POST /apps
  # POST /apps.xml
  def create
    @app = App.new(params[:app])

    respond_to do |format|
      if @app.save
        format.html { redirect_to(@app, :notice => 'App was successfully created.') }
        format.xml  { render :xml => @app, :status => :created, :location => @app }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /apps/1
  # PUT /apps/1.xml
  def update
    @app = App.get(params[:id])

    respond_to do |format|
      if @app.update(params[:app])
        format.html { redirect_to(@app, :notice => 'App was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @app.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /apps/1
  # DELETE /apps/1.xml
  def destroy
    @app = App.get(params[:id])
    @app.destroy

    respond_to do |format|
      format.html { redirect_to(apps_url) }
      format.xml  { head :ok }
    end
  end
end
