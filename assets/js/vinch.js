window.App = {};

App.search = {
  show: function() {
    $('#search').fadeIn(250);
    return $('#search input').focus();
  },
  hide: function() {
    return $('#search').fadeOut(250);
  }
};

$(function() {
  $('nav .inner .search').click(function() {
    App.search.show();
    return false;
  });
  $('#search').click(function(e) {
    if (e.target.nodeName !== 'INPUT') {
      return App.search.hide();
    }
  });
  $(document).bind('keydown', function(e) {
    var code;
    code = e.keyCode || e.which;
    if (!$('#search').is(':visible') && code === 70) {
      App.search.show();
      return false;
    }
  });
});
