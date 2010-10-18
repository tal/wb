class ThemesController < ApplicationController
  def show
    @theme = Theme[params[:id]]
  end
end
