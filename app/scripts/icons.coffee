class WB.Icon
  constructor: (@data)->
    @el = $(WB.t['themes/icon'](@data))
    @el.data('icon',this)
  
  app_id: ->
    @el.attr('app')
  theme_id: ->
    @el.attr('theme')
    