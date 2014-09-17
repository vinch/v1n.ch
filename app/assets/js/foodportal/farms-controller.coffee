foodPortalControllers.controller 'FarmsController', ($scope, farmService) ->
  
  $scope.isVisibleForm = false

  farmService.getAll().then (data) ->
    $scope.farms = data.results
  
  $scope.toggleForm = ->
    $scope.isVisibleForm = !$scope.isVisibleForm

  $scope.submitForm = ->
    console.log 'SUBMIT'