angular.module('foodPortalControllers').controller 'PlacesController', ($rootScope, $scope, geolocationService, placeService, placeCategoryService, yelpService, mapsService, utilsService) ->
  
  $scope.isVisibleForm = false
  $scope.currentPage = 1
  $scope.visiblePlaces = []
  $scope.places = []
  $scope.loading = false

  placeCategoryService.getAll().then (data) ->
    $scope.categories = data.results

  placeService.countAll().then (data) ->
    $scope.total = data.count

  getPlacesList = ->
    limit = 20
    $scope.loading = true
    placeService.getList($rootScope.position.coords, limit, ($scope.currentPage-1)*limit).then (data) ->
      $scope.loading = false
      for result in data.results
        result.distance = utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, result.position.latitude, result.position.longitude)
        $scope.places.push result

  if $rootScope.position
    getPlacesList()
  else
    geolocationService().then ((position) ->
      $rootScope.position = position
      getPlacesList()
    ), (err) ->
      $scope.error = true

  $scope.toggleVisiblePlace = (id) ->
    index = $scope.visiblePlaces.indexOf(id)
    if index != -1
      $scope.visiblePlaces.splice index, 1
    else
      $scope.visiblePlaces.push id

  $scope.loadMore = ->
    $scope.currentPage++
    getPlacesList()

  $scope.hideForm = ->
    $scope.isVisibleForm = false

  $scope.toggleForm = ->
    $scope.isVisibleForm = !$scope.isVisibleForm

  $scope.submitYelpForm = ->
    $scope.saving = true
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

            placeService.create(place).then ((data) ->
              $scope.saving = false
              $scope.hideForm()
              $scope.addPlaceYelpForm.$setPristine(true)
              place.objectId = data.objectId
              place.distance = utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, latitude, longitude)
              place.category.name = 'Others'
              place.category.name = category.name
              $scope.places.unshift place
              $scope.place = {}
              alert('Place successfully saved!')
            ), (err) ->
              $scope.saving = false
              alert('We couldn\'t save the data in the database.')
          else
            $scope.saving = false
            alert('We couldn\'t locate the address you provided.')
    else
      $scope.saving = false
      alert('This URL is not a valid Yelp URL.')

  $scope.submitForm = ->
    $scope.saving = true
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

        placeService.create($scope.place).then ((data) ->
          $scope.saving = false
          $scope.hideForm()
          $scope.addPlaceForm.$setPristine(true)
          $scope.place.objectId = data.objectId
          $scope.place.distance = utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, latitude, longitude)
          $scope.place.category.name = category.name
          $scope.places.unshift $scope.place
          $scope.place = {}
          alert('Place successfully saved!')
        ), (err) ->
          $scope.saving = false
          alert('We couldn\'t save the data in the database.')
      else
        $scope.saving = false
        alert('We couldn\'t locate the address you provided.')