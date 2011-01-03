class WB.AppStoreSearch
  constructor: (initText, @cb) ->
    popup = header: "Find Apps from the iTunes App Store."
    view = initText: initText
    
    popup.body = @body(view)
    @show(popup)
    
  show: (popup) ->
    @popup = new WB.Popup popup
    @popup.show()
    @el = @popup.el
    @el.find('.search .button').click(@updateValues)
    @el.find('.search .box').keyup (e) =>
      [down, up, enter, esc] = [38, 40, 13, 27]
      
      if e.which is esc
        @el.find('.search .box').val('')
      else if e.keyCode is enter
        @updateValues(e)
        return false
        
      true
    @updateValues()
    @popup
  
  updateValues: (val) =>
    if typeof(val) != 'string'
      val = @el.find('.search .box').val()
    
    @results().html('<img class="spinner" src="/images/spinner_circle.gif"/>')
    
    $.getJSON('/apps',{filter:val,from_app_store:1},@setResults)
  results: ->
    @resultsEl ||= @el.find('.results')
    
  setResults: (apps) =>
    @results().empty()
    $.each apps, (i,result) =>
      @addResult(result)
  hide: ->
    WB.Popup.hideActive()
  addResult: (app) ->
    # html = $.mustache(WB.t.popups.partials.app_store_search_result, app, WB.t.popups.partials)
    html = $(WB.t['popups/app_store_search_result'](app))
    html.find('.select').click (e) =>
      @hide()
      a = new WB.App(null,app)
      @cb(a)
    @results().append(html)
    
  body: (view) ->
    # Mustache.to_html(WB.t.popups.app_store_search, view, WB.t.popups.partials)
    WB.t['popups/app_store_search'](view)