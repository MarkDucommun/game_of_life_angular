#= require angular-mocks
context = describe

describe 'world', ->
  beforeEach module 'GameOfLife'

  # 3 - x x - -     - x x - - 3
  # 2 - x - x -     - - - x - 2
  # 1 x x x - -  => - - - x - 1
  # 0 x x - - x     x - x - - 0
  #   0 1 2 3 4     0 1 2 3 4

  beforeEach inject (WorldFactory) ->
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
    @coordinate = {x:0, y:0}
    @world = WorldFactory.new()

  it 'has a plane on which cells exist', ->
    expect(angular.isObject(@world.plane)).toBe true

  it 'has cells at particular coordinates on the plane', ->
    expect(@world.get(@coordinate)).toBe undefined

  it 'can create a live or dead cell at a particular coordinate', ->
    @world.set(@coordinate, true)
    expect(@world.get(@coordinate)).toBe true

  it 'can create living cells corresponding to a list of coordinates passed in', ->
    @world.initialize(@initial_coordinates)
    expect(@world.alive?({x:0, y:0})).toBe true
    expect(@world.alive?({x:0, y:1})).toBe true
    expect(@world.dead?({x:0, y:2})).toBe true

  context 'predicate methods', ->
    it 'can tell if a cell has been touched', ->
      expect(@world.untouched?(@coordinate)).toBe true
      @world.set(@coordinate, false)
      expect(@world.untouched?(@coordinate)).toBe false

    it 'can tell if a cell is alive', ->
      expect(@world.alive?(@coordinate)).toBe false
      @world.set(@coordinate, true)
      expect(@world.alive?(@coordinate)).toBe true

    it 'can tell if a cell is dead', ->
      expect(@world.dead?(@coordinate)).toBe true
      @world.set(@coordinate, true)
      expect(@world.dead?(@coordinate)).toBe false

  it 'can do something to every coordinate on a plane', ->
    @world.initialize(@initial_coordinates)
    test =
      method: -> true
    spyOn(test, 'method')
    @world.doToAllCells(test.method)
    expect(test.method.calls.count()).toBe 10

  it 'knows how many living neighbors a cell has', ->
    @world.initialize(@initial_coordinates)
    expect(@world.neighbors({x:0, y:0})).toBe 3
    expect(@world.neighbors({x:1, y:1})).toBe 5

  it 'can remove a cell from the plane', ->
    @world.set(@coordinate, true)
    @world.remove(@coordinate)
    expect(@world.untouched?(@coordinate)).toBe true

  it 'can cleanup any dead cells from the plane', ->
    @world.set(@coordinate, false)
    @world.set({x:1, y:1}, false)
    @world.cleanup()
    expect(Object.keys(@world.plane).length).toBe 0

  it 'can tell you how many cells it has', ->
    @world.initialize(@initial_coordinates)
    expect(@world.cellCount()).toBe 10

  context 'survival logic', ->
    beforeEach ->
      @world.initialize(@initial_coordinates)

    describe 'alive cell', ->
      it 'kills a cell with fewer than 2 neighbors', ->
        expect(@world.survives?({x:4, y:0})).toBe false

      it 'kills a cell with more than 3 neighbors', ->
        expect(@world.survives?({x:1, y:1})).toBe false

      it 'keeps cells with 2 or 3 neighbors alive', ->
        expect(@world.survives?({x:1, y:3})).toBe true
        expect(@world.survives?({x:0, y:0})).toBe true

    describe 'dead cell', ->
      it 'revives a cell with 3 neighbors', ->
        expect(@world.survives?({x:2, y:0})).toBe true

      it 'keeps cells with 2 or fewer neighbors and 4 or more neighbors dead', ->
        expect(@world.survives?({x:4, y:3})).toBe false
        expect(@world.survives?({x:2, y:2})).toBe false
