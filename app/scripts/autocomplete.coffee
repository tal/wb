window.WB ||= {}

class WB.AppAc
  constructor: (@input) ->
    @list = $('<ul class="list-app-ac"></ul>')
    @app_id_input = $('<input type="hidden"/>')
    @list.hide()
    @input.after(@list)
    @input.addClass('input-app-ac')
    @input.keydown(@keydown)
    @input.focusin(@focusin)
    @input.focusout(@focusout)
    @setText("Type an app name to view possible results")
    @apps = []
  
  keydown: (e) =>
    down = 38
    up = 40
    enter = 13
    
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
    else
      if (val = @input.val()).length > 1
        @getApps(val)
      else if val.length > 0
        @setText("Type at least three letters of of an app name")
      else
        @setText("Type an app name to view possible results")
      return true
  
  focusin: (e) =>
    @list.fadeIn('fast')
  focusout: (e) =>
    @list.fadeOut('fast')
  getApps: (val) ->
    console.time('Apps json call')
    $.getJSON '/apps', {limit:10,filter:val}, (apps) =>
      console.timeEnd('Apps json call')
      if apps && apps.length > 0
        @apps = []
        @list.empty()
        $.each apps, (i,app) =>
          a = new WB.App(app)
          @apps.push(a)
          @list.append(a.el)
        console.log("New apps: ",@apps)
        
      else
        @setText("No results found for "+val)
  setText: (text) ->
    li = $('<li class="text"></li>')
    li.text(text)
    @list.html(li)
    li
  
  moveUp: ->
    if @selected
      i = @apps.indexOf(@selected)
      console.log("Up pre-index = ",i)
      @select(@apps[i-1]) unless i is 0
    else
      @select(@apps[@apps.length-1])
    @selected
  
  moveDown: ->
    if @selected
      i = @apps.indexOf(@selected)
      console.log("Down pre-index = ",i)
      @select(@apps[i+1]) unless i is @apps.length-1
    else
      @select(@apps[0])
    @selected
      
  deselectAll: ->
    $.each(@apps, (i,app) ->
      app.deselect()
    )
  select: (app)->
    @deselectAll()
    
    @selected = app || @apps[0]
    @selected.select()
  
  set: (app) ->
    app ||= @selected
    
    
class WB.App
  constructor: (@data) ->
    @el = $('<li class="result app"></li>')
    img = $('<img class="app"/>')
    img.attr('src',@data.image).attr('width',49).attr('height',49)
    @el.data('app',this) # May not need this
    @id = @data.values.id
    @name = @data.values.name
    @el.html(@name)
    @el.prepend(img)
  select: ->
    @el.addClass('selected')
    this
  deselect: ->
    @el.removeClass('selected')
    this


jQuery(document).ready(($) ->
  console.time('Create autocomplete object')
  window.a = new WB.AppAc($("input:text:first"))
  console.timeEnd('Create autocomplete object')
)