angular.module('foodPortalControllers').controller 'MainController', ($scope, $state, $window) ->

  $scope.updateNavVisibility = ->
    $scope.visibleNav = if $window.innerWidth > 640 then true else false

  $scope.toggleNav = ->
    $scope.visibleNav = !$scope.visibleNav

  $scope.hideNav = ->
    $scope.visibleNav = false

  $scope.clickOutsideMenu = ->
    $scope.hideNav() if $scope.visibleNav && $window.innerWidth <= 640    

  $scope.updateNavVisibility()

  angular.element($window).bind 'resize', ->
    $scope.$apply ->
      $scope.updateNavVisibility()