window.WB ||= {}

WB.forms =
  putNewIcons: (icons, selector) ->
    $con = $(selector)
    $con.empty()
    WB.forms.icons = []
    col = []
    $.each icons, (i, icon) ->
      icon.index_in_set = i
      ico = WB.forms.addIcon(icon, $con)
      col.push(ico)
    
    $button = $("<a href='#' class='add button'>Add Another</a>")
    $button.click (e) =>
      icon = icons[0]
      icon.index_in_set = $con.find('.icon').size()
      WB.forms.addIcon(icon, $con)
      return false
    
    $con.after($button)
    
    col
  
  addIcon: (icon, $el) ->
    ico = new WB.forms.Icon(icon)
    $el.append(ico.$el)
    ico.auto = new WB.AppAc(ico.$el.find('.app input'))
    
    WB.forms.icons.push(ico)
    
    ico


class WB.forms.Icon
  constructor: (@data) ->
    t = WB.t.icons
    el = $.mustache(t.new_icon,@data,t.partials)
    @$el = $(el)