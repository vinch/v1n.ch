angular.module('foodPortalControllers').controller 'PlacesController', ($scope, geolocationService, yelpService, utilsService, placeService, placeCategoryService, mapsService) ->
  
  $scope.isVisibleForm = false
  $scope.visiblePlaces = []

  placeCategoryService.getAll().then (data) ->
    $scope.categories = data.results

  geolocationService().then ((position) ->
    $scope.position = position
    placeService.getAll(position.coords).then (data) ->
      $scope.places = []
      for result in data.results
        result.distance = utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, result.position.latitude, result.position.longitude)
        $scope.places.push result
  ), (err) ->
    $scope.error = true
  
  $scope.hideForm = ->
    $scope.isVisibleForm = false

  $scope.toggleForm = ->
    $scope.isVisibleForm = !$scope.isVisibleForm

  $scope.submitYelpForm = ->
    if $scope.place.yelp.url.indexOf('http://www.yelp.com/biz/') == 0
      slug = $scope.place.yelp.url.substring(24)
      category = JSON.parse($scope.place.yelp.category)
      yelpService.getBusiness(slug).then (data) ->
        place = {
          name: data.name
          category: {
            __type: 'Pointer'
            className: 'PlaceCategory'
            objectId: category.objectId
          }
          address: data.location.address[0]
          city: data.location.city
          zipcode: data.location.postal_code
          country: data.location.country_code
          website: data.url
        }
        mapsService.geocode(data.location.address[0] + ', ' + data.location.postal_code + ' ' + data.location.city + ', ' + data.location.country_code).then (data) ->
          if data.status == 'OK'
            latitude = data.results[0].geometry.location.lat
            longitude = data.results[0].geometry.location.lng
            place.position = {
              __type: 'GeoPoint'
              latitude: latitude
              longitude: longitude
            }
            place.formatted_address = data.results[0].formatted_address

            $scope.saving = true

            placeService.create(place).then ((data) ->
              $scope.saving = false
              $scope.hideForm()
              $scope.addPlaceYelpForm.$setPristine(true)
              place.objectId = data.objectId
              place.distance = utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, latitude, longitude)
              place.category.name = category.name
              $scope.places.unshift place
              $scope.place = {}
            ), (err) ->
              $scope.saving = false
              alert('We couldn\'t save the data in the database.')
          else
            alert('We couldn\'t locate the address you provided.')
    else
      alert('This URL is not a valid Yelp URL.')

  $scope.submitForm = ->
    mapsService.geocode($scope.place.address + ', ' + $scope.place.zipcode + ' ' + $scope.place.city + ', ' + $scope.place.country).then (data) ->
      if data.status == 'OK'
        latitude = data.results[0].geometry.location.lat
        longitude = data.results[0].geometry.location.lng
        formatted_address = data.results[0].formatted_address
        category = JSON.parse($scope.place.category)

        $scope.place.category = {
          __type: 'Pointer'
          className: 'PlaceCategory'
          objectId: category.objectId
        }
        $scope.place.position = {
          __type: 'GeoPoint'
          latitude: latitude
          longitude: longitude
        }
        $scope.place.formatted_address = formatted_address

        $scope.saving = true

        placeService.create($scope.place).then ((data) ->
          $scope.saving = false
          $scope.hideForm()
          $scope.addPlaceForm.$setPristine(true)
          $scope.place.objectId = data.objectId
          $scope.place.distance = utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, latitude, longitude)
          $scope.place.category.name = category.name
          $scope.places.unshift $scope.place
          $scope.place = {}
        ), (err) ->
          $scope.saving = false
          alert('We couldn\'t save the data in the database.')
      else
        alert('We couldn\'t locate the address you provided.')

  $scope.toggleVisiblePlace = (id) ->
    index = $scope.visiblePlaces.indexOf(id)
    if index != -1
      $scope.visiblePlaces.splice index, 1
    else
      $scope.visiblePlaces.push id