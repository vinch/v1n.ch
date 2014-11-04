angular.module('foodPortalControllers').controller 'PlacesPageController', ($scope, $stateParams, geolocationService, utilsService, placeService) ->

  limit = 20

  $scope.currentPage = $stateParams.page
  $scope.visiblePlaces = []

  placeService.countAll().then (data) ->
    totalPages = Math.ceil data.count/limit
    $scope.pages = (num for num in [1..totalPages])

  geolocationService().then ((position) ->
    $scope.position = position
    placeService.getList(position.coords, limit, ($scope.currentPage-1)*limit).then (data) ->
      $scope.places = []
      for result in data.results
        result.distance = utilsService.distance($scope.position.coords.latitude, $scope.position.coords.longitude, result.position.latitude, result.position.longitude)
        $scope.places.push result
  ), (err) ->
    $scope.error = true

  $scope.toggleVisiblePlace = (id) ->
    index = $scope.visiblePlaces.indexOf(id)
    if index != -1
      $scope.visiblePlaces.splice index, 1
    else
      $scope.visiblePlaces.push id