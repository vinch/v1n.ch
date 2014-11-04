foodPortalApp = angular.module 'foodPortalApp', ['ui.router', 'foodPortalControllers', 'foodPortalFilters']

foodPortalApp.config ($stateProvider, $urlRouterProvider) ->
  
  $urlRouterProvider.otherwise '/places'
  $urlRouterProvider.when '/places', '/places/1'

  $stateProvider.state 'places', {
    url: '/places'
    templateUrl: 'foodportal/partials/places'
    controller: 'PlacesController'
  }

  $stateProvider.state 'places.page', {
    url: '/:page'
    templateUrl: 'foodportal/partials/places-page'
    controller: 'PlacesPageController'
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