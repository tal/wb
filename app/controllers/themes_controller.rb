class ThemesController < ApplicationController
  
  def index
    @themes = Theme.all*50
  end
  
  def show
    @theme = Theme[params[:id]]
  end
end
