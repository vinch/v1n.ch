foodPortalFilters = angular.module 'foodPortalFilters', []

foodPortalFilters.filter 'prettyDistance', ->
  return (distance) ->
    if distance < 0.1
      return Math.round(distance*5280) + ' ft'
    else
      return distance.toFixed(1) + ' mi'