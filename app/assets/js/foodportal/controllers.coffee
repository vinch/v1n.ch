foodPortalControllers = angular.module 'foodPortalControllers', ['foodPortalServices']

foodPortalControllers.controller 'PlacesController', ->
  console.log 'PLACES'

foodPortalControllers.controller 'FarmsController', ($scope, farmService) ->
  farmService.getAll().then (data) ->
    $scope.farms = data.results

foodPortalControllers.controller 'StoresController', ->
  console.log 'STORES'

foodPortalControllers.controller 'RestaurantsController', ->
  console.log 'RESTAURANTS'

foodPortalControllers.controller 'WineriesController', ->
  console.log 'WINERIES'

foodPortalControllers.controller 'BreweriesController', ->
  console.log 'BREWERIES'

foodPortalControllers.controller 'ArticlesController', ->
  console.log 'ARTICLES'

foodPortalControllers.controller 'BooksController', ->
  console.log 'BOOKS'

foodPortalControllers.controller 'ProductsController', ->
  console.log 'PRODUCTS'

foodPortalControllers.controller 'RecipesController', ->
  console.log 'RECIPES'