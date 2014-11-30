foodPortalDirectives = angular.module 'foodPortalDirectives', []

foodPortalDirectives.directive 'clickOutside', ($document) ->
  restrict: 'A'
  link: (scope, elem, attr, ctrl) ->
    elem.bind 'click', (e) ->
      e.stopPropagation()
      return
    $document.bind 'click', ->
      scope.$apply attr.clickOutside
      return
    return