module ApplicationHelper
  @@items_per_page = nil
  
  def pager_params
    page = params[:page].full?{|p| p.to_i - 1}||0
    items = (params[:items]||params[:limit]).full?(:to_i)||@@items_per_page||50
    return items,page*items
  end
  
end
