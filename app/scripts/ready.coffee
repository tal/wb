jQuery(document).ready ($) ->
  
  # popup = new WB.Popup body: 'mybody', header: 'head'
  # popup.show()
  # new WB.AppStoreSearch('Reeder',console.log)
  
  $("#new_icon").submit (e) ->
    $this = $(this)
    $this.find('input:submit').attr('disabled','disabled')
    
    # Upon submit no longer let the user change the value for icon selectors
    # Global lock probably not neccisary, be careful if ajaxing forms in the futere
    $.each WB.forms.icons, (i, icon) ->
      icon.auto.unbindUnset()
    
    # false