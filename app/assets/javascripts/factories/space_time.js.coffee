@app.factory 'SpaceTimeFactory', (WorldFactory, CoordinateHelper) ->
  new: ->
    spaceTime =
      presentWorld: WorldFactory.new()

      futureWorld: WorldFactory.new()

      worlds: 0

      initialize: (coordinates) ->
        spaceTime.presentWorld.initialize(coordinates)

      updateCell: (coordinate) ->
        if spaceTime.futureWorld.untouched?(coordinate)
          alive = spaceTime.presentWorld.survives?(coordinate)
          spaceTime.futureWorld.set(coordinate, alive)

        neighbor_coordinates = CoordinateHelper.neighbors(coordinate)
        angular.forEach neighbor_coordinates, (neighbor_coordinate) ->
          if spaceTime.futureWorld.untouched?(neighbor_coordinate)
            alive = spaceTime.presentWorld.survives?(neighbor_coordinate)
            spaceTime.futureWorld.set(neighbor_coordinate, alive)

      updateTheFuture: ->
        spaceTime.presentWorld.doToAllCells (coordinate) ->
          spaceTime.updateCell(coordinate)
        spaceTime.futureWorld.cleanup()

      tic: ->
        spaceTime.updateTheFuture()
        spaceTime.presentWorld = spaceTime.futureWorld
        spaceTime.futureWorld = WorldFactory.new()
        spaceTime.worlds += 1
