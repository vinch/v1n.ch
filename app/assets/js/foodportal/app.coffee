foodPortalApp = angular.module 'foodPortalApp', ['ui.router', 'foodPortalControllers']

foodPortalApp.config ($stateProvider, $urlRouterProvider) ->
  
  $urlRouterProvider.otherwise '/places'
  $urlRouterProvider.when('/places', '/places/farms')

  $stateProvider.state 'places', {
    url: '/places'
    templateUrl: 'foodportal/partials/places'
    controller: 'PlacesController'
  }

  $stateProvider.state 'places.farms', {
    url: '/farms'
    templateUrl: 'foodportal/partials/farms'
    controller: 'FarmsController'
  }

  $stateProvider.state 'places.stores', {
    url: '/stores'
    templateUrl: 'foodportal/partials/stores'
    controller: 'StoresController'
  }

  $stateProvider.state 'places.restaurants', {
    url: '/restaurants'
    templateUrl: 'foodportal/partials/restaurants'
    controller: 'RestaurantsController'
  }

  $stateProvider.state 'places.wineries', {
    url: '/wineries'
    templateUrl: 'foodportal/partials/wineries'
    controller: 'WineriesController'
  }

  $stateProvider.state 'places.breweries', {
    url: '/breweries'
    templateUrl: 'foodportal/partials/breweries'
    controller: 'BreweriesController'
  }

  $stateProvider.state 'articles', {
    url: '/articles'
    templateUrl: 'foodportal/partials/articles'
    controller: 'ArticlesController'
  }

  $stateProvider.state 'books', {
    url: '/books'
    templateUrl: 'foodportal/partials/books'
    controller: 'BooksController'
  }

  $stateProvider.state 'products', {
    url: '/products'
    templateUrl: 'foodportal/partials/products'
    controller: 'ProductsController'
  }

  $stateProvider.state 'recipes', {
    url: '/recipes'
    templateUrl: 'foodportal/partials/recipes'
    controller: 'RecipesController'
  }