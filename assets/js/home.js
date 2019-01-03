App.Posts = {
  get: function(data, callback) {
    return $.ajax({
      url: '/api/posts',
      data: data,
      success: callback.success,
      error: callback.error
    });
  }
};

App.Photos = {
  get: function(data, callback) {
    return $.ajax({
      url: '/api/photos',
      data: data,
      success: callback.success,
      error: callback.error
    });
  }
};

App.View = {
  render: function(name, data) {
    var html, source, template;
    source = $('#' + name + '-template').html();
    template = Handlebars.compile(source);
    html = template(data);
    return $('#' + name).append(html);
  }
};

$(function() {
  App.Photos.get({
    limit: 4
  }, {
    success: function(res) {
      return App.View.render('photos', {
        photos: res
      });
    },
    error: function(err) {
      return console.log(err);
    }
  });
  return App.Posts.get({
    limit: 3
  }, {
    success: function(res) {
      return App.View.render('posts', {
        posts: res
      });
    },
    error: function(err) {
      return console.log(err);
    }
  });
});
