foodPortalServices = angular.module 'foodPortalServices', []

foodPortalServices.constant 'apiEndpoint', 'https://api.parse.com/1'

foodPortalServices.factory 'farmService', (requestService, apiEndpoint) ->
  return {
    getAll: ->
      return requestService.get apiEndpoint + '/classes/Farm'
  }

foodPortalServices.factory 'requestService', ($http, $q) ->  
  return {
    get: (url, params) ->
      @http 'GET', url, params

    post: (url, data) ->
      @http 'POST', url, data

    put: (url, data) ->
      @http 'PUT', url, data

    delete: (url) ->
      @http 'DELETE', url

    http: (method, url, data) ->
      config = {
        method: method
        url: url
        headers: {
          'X-Parse-Application-Id': 'MaouOA5zAXZiXWP7Xz4b5fNr6foJQfFwbm9KmWkt'
          'X-Parse-REST-API-Key': 'QMqU5f7l0XdDbXqpA31zM5wabr5t4TGORDIE6YhB'
        }
      }

      if data
        if method == 'GET'
          config.params = data
        else
          config.data = JSON.stringify data

      d = $q.defer()

      $http(config).success((data, status, headers, config) =>
        d.resolve data
      ).error((data, status, headers, config) =>
        d.reject data
      )

      return d.promise

  }