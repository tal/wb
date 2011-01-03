class WB.Popup
  constructor: (view) ->
    
    if view['template'] && WB.t["popups/#{view['template']}"]
      @el = $(WB.t["popups/#{view['template']}"](view))
    else
      @el = $(WB.t["popups/default"](view))
    @el.hide()
    
    WB.Popup._all.push(@el)
    
  show: ->
    WB.Popup.hideActive()
    WB.Popup._overlay.show()
    WB.Popup._active = @el
    $body = $('body')
    left = ($body.width()-400)/2
    @el.css('left',left).show()
    
    @el.find('a.close').click (e) ->
      WB.Popup.hideActive()
    
    $body.append(@el)
    @el.show()

WB.Popup._all = []
jQuery(document).ready ($) ->
  WB.Popup._overlay = $('<div id="facebox_overly"></div>').hide().appendTo('body')
WB.Popup.hideActive = ->
  WB.Popup._overlay.hide()
  WB.Popup._active.remove() if WB.Popup._active