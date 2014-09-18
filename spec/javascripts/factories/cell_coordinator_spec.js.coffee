#= require angular-mocks
context = describe

describe 'CellCoordinator', ->
  beforeEach module 'GameOfLife'

  beforeEach inject (CellCoordinatorFactory) ->
    @cellCoordinator = CellCoordinatorFactory.new()

  it 'can have cell apis', ->
    expect(angular.isArray @cellCoordinator.cellApis).toBe true

  it 'store a cell api', ->
    cellApi = {}
    expect(@cellCoordinator.cellApis.length).toBe 0
    @cellCoordinator.addCellApi(cellApi)
    expect(@cellCoordinator.cellApis.length).toBe 1

  it 'can call a method on each cell api that it is holding', ->
    cellApi =
      method: ->
    thing = true
    @cellCoordinator.addCellApi(cellApi)
    @cellCoordinator.addCellApi(cellApi)
    spyOn(cellApi, 'method')
    @cellCoordinator.callOnEachCellApi('method')
    expect(cellApi.method.calls.count()).toBe 2
