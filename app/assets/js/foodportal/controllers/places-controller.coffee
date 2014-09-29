angular.module('foodPortalControllers').controller 'PlacesController', ($scope, geolocationService, utilsService, placeService, placeCategoryService, mapsService) ->
  
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
  
  $scope.toggleForm = ->
    $scope.isVisibleForm = !$scope.isVisibleForm

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
          $scope.isVisibleForm = false
          $scope.addPlaceForm.$setPristine(true)
          $scope.place.objectId = data.objectId
          $scope.place.distance = utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, latitude, longitude)
          $scope.place.category.name = category.name
          $scope.places.push $scope.place
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