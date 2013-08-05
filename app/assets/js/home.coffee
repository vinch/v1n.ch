window.App = {}

App.Posts = {
  get: (data, callback) ->
    $.ajax {
      url: '/api/posts'
      data: data
      success: callback.success
      error: callback.error
    }
}

App.Photos = {
  get: (data, callback) ->
    $.ajax {
      url: '/api/photos'
      data: data
      success: callback.success
      error: callback.error
    }
}

App.View = {
  render: (name, data) ->
    source = $('#' + name + '-template').html()
    template = Handlebars.compile source
    html = template data
    $('#' + name).append html
}

$ ->
  App.Posts.get { limit: 3 }, {
    success: (res) ->
      App.View.render 'posts', {
        posts: res
      }
    error: (err) ->
      console.log err
  }