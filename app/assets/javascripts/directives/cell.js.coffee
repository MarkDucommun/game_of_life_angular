@app.directive 'cell', ->
  restrict: 'A'
  scope: true
  link: (scope, element, attrs) ->
    scope.x = parseInt(attrs.x)
    scope.y = parseInt(attrs.y)

    cellApi =
      left: -> scope.x -= 1
      right: -> scope.x += 1
      up: -> scope.y += 1
      down: -> scope.y -= 1
      resize: (newSize) ->
        element.css('width', newSize + 'px')
        element.css('height', newSize + 'px')

    scope.addCell(cellApi)

    scope.alive = ->
      scope.spaceTime.presentWorld.alive?({x: scope.x, y: scope.y})

    element.bind 'click', ->
      scope.$apply ->
        if scope.alive()
          scope.kill(scope.x, scope.y)
        else
          scope.resurrect(scope.x, scope.y)
