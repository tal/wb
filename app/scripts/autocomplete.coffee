window.WB ||= {}

class WB.AppAc
  constructor: (@input) ->
    @list = $('<ul class="list-app-ac"></ul>')
    @app_id_input = $('<input type="hidden"/>')
    @app_id_input.attr('name', @input.attr('name'))
    @input.removeAttr('name')
    @input.after(@app_id_input)
    @input.after(@list)
    @input.addClass('input-app-ac')
    @input.keydown(@keydown)
    @input.keyup(@keyup)
    @input.focusin(@focusin)
    @input.focusout(@focusout)
    @list.hide()
    @setText("Type an app name to view possible results")
    @apps = []
  
  keyup: (e) =>
    [down, up, enter, esc] = [38, 40, 13, 27]
    
    if e.keyCode is esc
      @input.val('')
    
    if e.keyCode not in [up,down,enter]
      if (val = @input.val()).length > 2
        @getApps(val)
      else if val.length > 0
        @setText("Type at least three letters of of an app name")
      else
        @setText("Type an app name to view possible results")
    
    return true
  keydown: (e) =>
    [down, up, enter, esc] = [38, 40, 13, 27]
    
    if e.keyCode in [up,down,enter]
      e.preventDefault()
      
      return false unless @apps.length > 0
      
      if e.keyCode is down
        @moveUp()
      else if e.keyCode is up
        @moveDown()
      else if e.keyCode is enter
        @set() if @selected?
      return false
  
  focusin: (e) =>
    @list.fadeIn('fast')
  focusout: (e) =>
    @list.fadeOut('fast')
  processApps: (apps) ->
    @apps = []
    @list.empty()
    
    
  getApps: (val) ->
    console.time('Apps json call')
    $.getJSON '/apps', {limit:10,filter:val}, (apps) =>
      console.timeEnd('Apps json call')
      view = val: val, results: apps
      
      $results = @$results(view)
      
      @apps = []
      $results.find('li.app').each (i,el) =>
        app = new WB.App(el,apps[i])
        @apps.push(app)
      
      $results.find('a.search_itunes').click (e) =>
        as = new WB.AppStoreSearch(val, @set)
        false
      
      @list.html($results)
      
  
  $results: (view) ->
    $.mustache(WB.t.apps_autocomplete.results,view,WB.t.apps_autocomplete.partials)
  setText: (text) ->
    view = text: text
    $results = @$results(view)
    @list.html($results)
    $results
    
  moveUp: ->
    if @selected
      i = @apps.indexOf(@selected)
      @select(@apps[i-1]) unless i is 0
    else
      @select(@apps[@apps.length-1])
    @selected
  
  moveDown: ->
    if @selected
      i = @apps.indexOf(@selected)
      @select(@apps[i+1]) unless i is @apps.length-1
    else
      @select(@apps[0])
    @selected
      
  deselectAll: ->
    $.each @apps, (i,app) ->
      app.deselect()
    
  select: (app)->
    @deselectAll()
    
    @selected = app || @apps[0]
    @selected.select()
  
  set: (app) =>
    app ||= @selected
    @app_id_input.val(app.id)
    @input.hide()
    @list.hide()
    
    @img = $('<div class="app"/>')
    img = $("<img />'")
    img.attr('src',app.data.image).attr('width',59).attr('height',59)
    @img.append(img)
    @img.append("<span class='name'>#{app.name}</span>")
    @img.click(@unset)
    @input.after(@img)
  
  unset: =>
    @img.remove()
    @input.show()
    @app_id_input.val('')
  
  unbindUnset: ->
    @img.unbind('click',@unset)
  
class WB.App
  constructor: (@el,@data) ->
    @$el = $(@el) if @el?
    @id = @data.values.id
    @name = @data.values.name
    @image = @data.image
  
  select: ->
    @$el.addClass('selected')
  
  deselect: ->
    @$el.removeClass('selected')