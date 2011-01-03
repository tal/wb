jQuery(document).ready ($) ->
  
  # popup = new WB.Popup body: 'mybody', header: 'head'
  # popup.show()
  # new WB.AppStoreSearch('Reeder',console.log)
  
  $('.icons .icon-image').live('mouseover', (e) ->
    $(this).addClass('show-size')
  ).live('mouseleave', (e) ->
    $(this).removeClass('show-size')
  )
  
  # i = new WB.IconCompare($('.icon:first'))
  # i.get_default_icon()
  
  $(window).bind 'popstate', ->
    if match = location.pathname.match(/(themes)(?:\/(\d+))?/)
      [l, themes, theme_id] = match
      
      if theme_id && t = WB.Theme.find(theme_id)
        t.show_icons()
      else if WB.noHistory
        window.location.href = location.pathname
      else if t = WB.Theme.active
        t.hide_icons()
      
  
  $('.show-all-icons').live 'click', (e) ->
    return true if WB.noHistory
    
    theme = $(this).closest('.theme').data('theme')
    history.pushState({ path: this.path }, '', this.href)
    theme.show_icons()
    
    false
  
  $('.hide-all-icons').live 'click', (e) ->
    return true if WB.noHistory
    
    theme = $(this).closest('.theme').data('theme')
    history.pushState({ path: this.path }, '', this.href)
    theme.hide_icons()
    
    false
  
  $('.icons .icon').live 'click', (e) ->
    return false if WB.IconCompare._active
    i = new WB.IconCompare(this)
    i.get_default_icon()
  
  $("#new_icon").submit (e) ->
    $this = $(this)
    $this.find('input:submit').attr('disabled','disabled')
    
    # Upon submit no longer let the user change the value for icon selectors
    # Global lock probably not neccisary, be careful if ajaxing forms in the futere
    $.each WB.forms.icons, (i, icon) ->
      icon.auto.unbindUnset()
    
    # false