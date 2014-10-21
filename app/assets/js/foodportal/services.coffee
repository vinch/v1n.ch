foodPortalServices = angular.module 'foodPortalServices', []

foodPortalServices.factory 'placeCategoryService', (requestService) ->
  return {
    getAll: ->
      data = {
        order: 'name'
      }
      return requestService.get 'https://api.parse.com/1/classes/PlaceCategory', data, { 'X-Parse-Application-Id': 'MaouOA5zAXZiXWP7Xz4b5fNr6foJQfFwbm9KmWkt', 'X-Parse-REST-API-Key': 'QMqU5f7l0XdDbXqpA31zM5wabr5t4TGORDIE6YhB' }
  }

foodPortalServices.factory 'placeService', (requestService) ->
  return {
    getAll: (position) ->
      data = {
        include: 'category'
        where: JSON.stringify {
          position: {
            '$nearSphere': {
              __type: 'GeoPoint'
              latitude: position.latitude
              longitude: position.longitude
            }
          }
        }
      }
      return requestService.get 'https://api.parse.com/1/classes/Place', data, { 'X-Parse-Application-Id': 'MaouOA5zAXZiXWP7Xz4b5fNr6foJQfFwbm9KmWkt', 'X-Parse-REST-API-Key': 'QMqU5f7l0XdDbXqpA31zM5wabr5t4TGORDIE6YhB' }
    create: (data) ->
      return requestService.post 'https://api.parse.com/1/classes/Place', data, { 'X-Parse-Application-Id': 'MaouOA5zAXZiXWP7Xz4b5fNr6foJQfFwbm9KmWkt', 'X-Parse-REST-API-Key': 'QMqU5f7l0XdDbXqpA31zM5wabr5t4TGORDIE6YhB' }
  }

foodPortalServices.factory 'yelpService', (requestService) ->
  return {
    getBusiness: (slug) ->
      parameters = {
        oauth_consumer_key : 'HJiPNkgKG7FKpygGzZ01Lg'
        oauth_nonce : '1234567890'
        oauth_timestamp : '1412051546589'
        oauth_token : 'zx-u71I2k7hSZ5CgOay5UBO3OTGt6IUr'
        oauth_signature_method : 'HMAC-SHA1'
        oauth_version: '1.0'
      }
      signature = oauthSignature.generate('get', 'http://api.yelp.com/v2/business/' + slug, parameters, 'FuwJgbO9O83Jf0YEVw2gwIbEqgA', 'ZmhMnwHyhW2LStD3WCwn1OS4Rpo')
      return requestService.get '/proxy?url=' + encodeURIComponent('http://api.yelp.com/v2/business/' + slug + '?oauth_consumer_key=HJiPNkgKG7FKpygGzZ01Lg&oauth_nonce=1234567890&oauth_timestamp=1412051546589&oauth_token=zx-u71I2k7hSZ5CgOay5UBO3OTGt6IUr&oauth_signature_method=HMAC-SHA1&oauth_version=1.0&oauth_signature=' + signature)
  }

foodPortalServices.factory 'utilsService', ->
  return {
    distance: (lat1, lon1, lat2, lon2) ->
      R = 3961 # Earth radius in miles
      dLat = @deg2rad(lat2-lat1)
      dLon = @deg2rad(lon2-lon1) 
      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.cos(@deg2rad(lat1)) * Math.cos(@deg2rad(lat2)) * Math.sin(dLon/2) * Math.sin(dLon/2)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)) 
      d = R * c
      return d
    deg2rad: (deg) ->
      return deg * (Math.PI/180)
  }

foodPortalServices.factory 'geolocationService', ($q, $window, $rootScope) ->
  return ->
    deferred = $q.defer()
    unless 'geolocation' of $window.navigator
      deferred.reject 'Geolocation is not supported'
    else
      $window.navigator.geolocation.getCurrentPosition ((position) ->
        $rootScope.$apply ->
          deferred.resolve position
      ), (err) ->
        deferred.reject err.message

    return deferred.promise

foodPortalServices.factory 'mapsService', (requestService) ->
  return {
    geocode: (address) ->
      return requestService.get 'https://maps.googleapis.com/maps/api/geocode/json', { address: address, key: 'AIzaSyDv8vJ4PHMEItOe3zeMoeVEU21RSL1oSBo' }
  }

foodPortalServices.factory 'requestService', ($http, $q) ->  
  return {
    get: (url, params, headers) ->
      @http 'GET', url, params, headers

    post: (url, data, headers) ->
      @http 'POST', url, data, headers

    put: (url, data, headers) ->
      @http 'PUT', url, data, headers

    delete: (url, headers) ->
      @http 'DELETE', url, headers

    http: (method, url, data, headers) ->
      config = {
        method: method
        url: url
        headers: headers
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