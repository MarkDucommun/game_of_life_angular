@app.factory 'WorldFactory', (CoordinateHelper) ->
  new: ->
    world =
      plane: {}

      initialize: (coordinates) ->
        angular.forEach coordinates, (coordinate) ->
          world.set(coordinate, true)

      get: (coordinate) ->
        world.plane[JSON.stringify(coordinate)]

      set: (coordinate, alive) ->
        world.plane[JSON.stringify(coordinate)] = alive

      untouched: (coordinate) ->
        world.get(coordinate) == undefined

      alive: (coordinate) ->
        world.get(coordinate) == true

      dead: (coordinate) ->
        world.get(coordinate) != true

      cellCount: ->
        Object.keys(world.plane).length

      survives: (coordinate) ->
        neighbor_count = world.neighbors(coordinate)
        alive = world.alive?(coordinate)
        return true if alive && neighbor_count == 2 || neighbor_count == 3
        return true if !alive && neighbor_count == 3
        false

      doToAllCells: (method) ->
        angular.forEach world.plane, (alive, coordinate) ->
          coordinateObj = JSON.parse(coordinate)
          method(coordinateObj, alive)

      neighbors: (coordinate) ->
        neighbor_coordinates = CoordinateHelper.neighbors(coordinate)
        neighbor_count = 0

        angular.forEach neighbor_coordinates, (neighbor_coordinate) ->
          neighbor_count += 1 if world.alive?(neighbor_coordinate)

        neighbor_count

      remove: (coordinate) ->
        coordinate = JSON.stringify(coordinate) if angular.isObject(coordinate)
        delete world.plane[coordinate]

      cleanup: ->
        world.doToAllCells (coordinate, alive) ->
          world.remove(coordinate) unless alive
