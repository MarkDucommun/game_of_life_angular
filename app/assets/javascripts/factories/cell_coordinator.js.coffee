@app.factory 'CellCoordinatorFactory', ->
  new: ->
    cellCoordinator =
      cellApis: []

      addCellApi: (cellApi) -> cellCoordinator.cellApis.push(cellApi)

      callOnEachCellApi: (method, argument) ->
        angular.forEach cellCoordinator.cellApis, (cellApi) ->
          cellApi[method](argument)
