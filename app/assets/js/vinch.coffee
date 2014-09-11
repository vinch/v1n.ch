window.App = {}

App.search = {
  show: ->
    $('#search').fadeIn(250)
    $('#search input').focus()
  hide: ->
    $('#search').fadeOut(250)
}

$ ->
  $('nav .inner .search').click ->
    App.search.show()
    return false
  
  $('#search').click (e) ->
    App.search.hide() if (e.target.nodeName != 'INPUT')
  
  $(document).bind 'keydown', (e) ->
    code = e.keyCode || e.which
    if (!$('#search').is(':visible') && code == 70)
      App.search.show()
      return false

  return