class WB.Theme
  constructor: (@data, @icons) ->
    @el = $(WB.t['themes/theme'](@data))
    @el.data('theme',this)
    @icons_el = @el.find('.icons')
    WB.Theme.all.push(this)
    
    if @data.icons
      @icons = []
      $.each @data.icons, (i, icon) =>
        @icons.push(new WB.Icon(icon))
    
  show_icons: ->
    @full_size()
    @el.find('.hide-all-icons').show()
    @el.find('.show-all-icons').hide()
    @loading_icons()
  hide_icons: ->
    WB.Theme.active = null
    @el.find('.hide-all-icons').hide()
    @el.find('.show-all-icons').show()
    $.each WB.Theme.all, (i,theme) ->
      theme.el.show()
    
    $.scrollTo(@scrollTop+@distFromTop)
    $.scrollTo(@scrollTop,WB.Theme.slideSpeed)
    @el.animate {'height': @el.find('.info').height()}, WB.Theme.slideSpeed, =>
      @icons_el.empty()
    
  loading_icons: ->
    @icons_el.hide().append('<div class="spinner"></div>').slideDown(WB.Theme.slideSpeed)
    if @icons
      @insert_icons()
    else
      $.getJSON "/theme/#{@data.values.id}/icons.json", {items:@max_icons||500}, (array) =>
        @icons = []
        $.each array, (i,icon) =>
          @icons.push(new WB.Icon(icon))
        
        @insert_icons()
  insert_icons: ->
    @icons_el.empty()
    
    $.each @icons, (i, icon) =>
      @icons_el.append(icon.el)
      
    @icons_el.fadeIn(WB.Theme.slideSpeed)
  
  full_size: ->
    
    if WB.Theme.active
      WB.Theme.active.hide_icons()
    
    WB.Theme.active = this
    
    position = @el.position()
    $win = $(window)
    @scrollTop = $win.scrollTop()
    viewportSize = $win.height()
    
    @distFromTop = position.top - @scrollTop
    $('#themes').animate {'margin-top':-1*@distFromTop}
    startIndex = WB.Theme.all.indexOf(this)
    
    height = @el.height()
    if height < viewportSize
      height = viewportSize
    
    @el.animate {'height': height}, WB.Theme.slideSpeed, ->
      $.scrollTo(0)
      $('#themes').css('margin-top',0)
      $.each WB.Theme.all, (i,theme) ->
        theme.el.hide() if i != startIndex
    
  

WB.Theme.all = []
WB.Theme.slideSpeed = 'slow'
WB.Theme.find = (id) ->
  theme = null
  $.each WB.Theme.all, (i,t) ->
    if t.data.id == parseInt(id)
      theme = t
      return false
  theme
