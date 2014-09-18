#= require angular-mocks

describe 'CoordinateHelper', ->
  beforeEach module 'GameOfLife'

  beforeEach inject (CoordinateHelper) ->
    @coordHelper = CoordinateHelper

  it 'can add one coordinate to another', ->
      a = {x:1, y:1}
      b = {x:2, y:2}
      expected = {x:3, y:3}
      expect(@coordHelper.add(a, b)).toEqual expected

  it 'can locate all of a cells neighbors', ->
      # Cell at x:1, y:1
      cellNeighbors = [
        {x:1, y:2},  # top
        {x:2, y:2},  # top-right
        {x:2, y:1},  # right
        {x:2, y:0},  # bottom-right
        {x:1, y:0},  # bottom
        {x:0, y:0},  # bottom-left
        {x:0, y:1},  # left
        {x:0, y:2},  # top-left
      ]
      expect(@coordHelper.neighbors({x:1, y:1})).toEqual cellNeighbors
