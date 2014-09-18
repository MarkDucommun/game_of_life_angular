#= require angular-mocks
context = describe

describe 'SpaceTime', ->
  beforeEach module 'GameOfLife'

  # 3 - x x - -     - x x - - 3
  # 2 - x - x -     - - - x - 2
  # 1 x x x - -  => - - - x - 1
  # 0 x x - - x     x - x - - 0
  #   0 1 2 3 4     0 1 2 3 4

  beforeEach inject (SpaceTimeFactory) ->
    @spaceTime = SpaceTimeFactory.new()
    @initial_coordinates = [
      {x:0, y:0},
      {x:0, y:1},
      {x:1, y:0},
      {x:1, y:1},
      {x:1, y:2},
      {x:1, y:3},
      {x:2, y:1},
      {x:2, y:3},
      {x:3, y:2},
      {x:4, y:0}
    ]

  it 'has a present world', ->
    expect(angular.isObject @spaceTime.presentWorld).toBe true

  it 'has a future world', ->
    expect(angular.isObject @spaceTime.futureWorld).toBe true

  it 'can initialize its first world to a particular state', ->
    spyOn(@spaceTime.presentWorld, 'initialize')
    @spaceTime.initialize(@initial_coordinates)
    expect(@spaceTime.presentWorld.initialize).
      toHaveBeenCalledWith(@initial_coordinates)

  it 'can check the status of a cell and its 8 neighbors', ->
    @spaceTime.updateCell({x:1, y:1})
    futureWorld = @spaceTime.futureWorld
    shouldBeTouched = [
      {x:1, y:1},
      {x:1, y:2},
      {x:2, y:2},
      {x:2, y:1},
      {x:2, y:0},
      {x:1, y:0},
      {x:0, y:0},
      {x:0, y:1},
      {x:0, y:2}
    ]
    angular.forEach shouldBeTouched, (coordinate) ->
      expect(futureWorld.untouched?(coordinate)).toBe false

  it 'can update the future world to reflect the cells that should survive' +
  ' based on the status of the present world', ->
    @spaceTime.initialize(@initial_coordinates)
    @spaceTime.updateTheFuture()
    futureWorld = @spaceTime.futureWorld
    expectedFutureCoordinates = [
      {x:0, y:0},
      {x:1, y:3},
      {x:2, y:0},
      {x:2, y:3},
      {x:3, y:1},
      {x:3, y:2}
    ]
    angular.forEach expectedFutureCoordinates, (coordinate) ->
      expect(futureWorld.alive?(coordinate)).toBe true

  it 'can move into the future', ->
    @spaceTime.initialize(@initial_coordinates)
    oldFuture = @spaceTime.futureWorld
    expect(@spaceTime.presentWorld.plane).not.toEqual oldFuture.plane
    @spaceTime.tic()
    expect(@spaceTime.presentWorld.plane).toEqual oldFuture.plane

  it 'knows how many worlds have existed', ->
    @spaceTime.initialize(@initial_coordinates)
    @spaceTime.tic()
    @spaceTime.tic()
    expect(@spaceTime.worlds).toBe 2
