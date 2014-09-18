@app.service 'CoordinateHelper', ->
  @add = (coordinate, transform) ->
    result = {}
    angular.forEach coordinate, (value, key) ->
      result[key] = value + transform[key]
    result

  @neighbors = (coordinate) ->
    that = @
    neighbors = []
    angular.forEach @neighbor_transformations,  (transformation) ->
      neighbors.push that.add(coordinate, transformation)
    neighbors

  @neighbor_transformations = [
    {x:0,  y:1},   # top
    {x:1,  y:1},   # top-right
    {x:1,  y:0},   # right
    {x:1,  y:-1},  # bottom-right
    {x:0,  y:-1},  # bottom
    {x:-1, y:-1},  # bottom-left
    {x:-1, y:0},   # left,
    {x:-1, y:1}    # top-left
  ]

  return
