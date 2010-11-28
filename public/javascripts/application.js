window.WB = {};

function autocomplete(e) {
  var $this = $(this),
      val = $this.val(),
      $autocomplete = $this.next('.autocomplete'),
      $sayType = $autocomplete.find('.say-type');
      $oResults = $autocomplete.find('.results');
  
  if (e.keyCode == 38 || e.keyCode == 40) {
    var $selected = $oResults.find('.result.selected');
    
    if (e.keyCode == 38) {
      if ($selected.size()==0) {
        $selected = $oResults.find('.result:last');
        $newSel = $selected
      } else {
        var $newSel = $selected.prev();
      }
    } else if (e.keyCode == 40) {
      if ($selected.size()==0) {
        $selected = $oResults.find('.result:first');
        var $newSel = $selected;
      } else {
        var $newSel = $selected.next();
      }
    }
    
    if ($newSel.size()==0) {
      $newSel = $selected;
    }
    
    $autocomplete.find('.result').removeClass('selected');
    $newSel.addClass('selected');
    $this.val($newSel.text());
    $('#icon_app_id').val($newSel.data('app_id'));
    return false;
  }
  
  function setMessage(txt) {
    $oResults.hide();
    $sayType.find("li").text(txt);
    $sayType.show();
  }
  
  if (val.length > 2) {
    $.getJSON('/apps',{limit:10,filter:val},function(apps){
      
      if (apps && apps.length > 0) {
        var $results = $('<ul class="results"></ul>');
        $.each(apps,function(i,app) {
          var $result = $('<li class="result"></li>');
          
          $result.text(app.values.name);
          $result.data('app_id',app.values.id);
          
          $results.append($result);
        });
        
        $sayType.hide();
        $oResults.show().replaceWith($results);
      } else {
        setMessage('No results found for '+val);
      }
    });
  } else if (val.length == 0) {
    setMessage('Type an app name to view possible results');
  } else {
    setMessage('Type at least two letters of of an app name');
  }
}

$(document).ready(function($){
  $('.icon_app_name input:text').keydown(autocomplete)
  .focusin(function(e){
    $(this).next('.autocomplete').show();
  }).focusout(function(e){
    $(this).next('.autocomplete').hide();
  });
});
