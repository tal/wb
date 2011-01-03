class WB.IconCompare
  constructor: (obj) ->
    if WB.IconCompare._active
      WB.IconCompare._active.hide()
    
    if obj instanceof HTMLElement
      @icon = $.data(obj,'icon')
    else if obj instanceof WB.Icon
      @icon = obj
    else if obj instanceof $
      @icon = obj.data('icon')
    
    WB.IconCompare._active = this
    
  get_default_icon: ->
    
    @el = $(WB.t['themes/icon_compare']({}))
    @el.css('z-index','998')
    @icon.el.css('z-index','999')
    
    @icon.el.closest('.icons')
    WB.Popup._overlay.show().one 'click', (e) =>
      @hide()
      
    $('body').append(@el)
    
    @position()
    
    
    $.getJSON '/icons',{default: 1, limit: 1, app_id: @icon.app_id(), with:['app_name']}, (data) =>
      if data && data[0]
        @default_icon = new WB.Icon(data[0])
        @el.prepend("<h2>#{data[0].app_name}</h2>")
        @el.find('.default').append(@default_icon.el)
        @position()
      
  position: ->
    position = @icon.el.offset()
    dummy_loc = @el.find('.dummy').position()
    position.top -= dummy_loc.top
    position.left -= dummy_loc.left
    @el.css(position)
  
  hide: ->
    WB.IconCompare._active = null
    @icon.el.css('z-index','')
    @el.remove()
    WB.Popup._overlay.hide()
      