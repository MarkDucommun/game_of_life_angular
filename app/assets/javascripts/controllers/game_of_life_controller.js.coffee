@app.controller 'GameOfLifeController', ($scope, $timeout, $window, SpaceTimeFactory, CellCoordinatorFactory) ->

  ##### Cell Coordinator #####

  cellCoordinator = CellCoordinatorFactory.new()

  $scope.addCell = cellCoordinator.addCellApi

  $scope.left = -> cellCoordinator.callOnEachCellApi 'left'

  $scope.right = -> cellCoordinator.callOnEachCellApi 'right'

  $scope.up = -> cellCoordinator.callOnEachCellApi 'up'

  $scope.down = -> cellCoordinator.callOnEachCellApi 'down'

  $scope.resizeCells = (size) -> cellCoordinator.callOnEachCellApi 'resize', size



  ##### Grid manager #####

  height = $window.innerHeight - 60
  width = $window.innerWidth

  $scope.$watch 'cellWidth', (newSize) ->
    $scope.resizeCells(newSize)

  $scope.$on 'ngRepeatFinished', ->
    $scope.resizeCells($scope.cellWidth)

  $scope.cellWidth = Math.floor(width / 65)
  $scope.columns = [0..65]
  $scope.rows = [Math.floor(height / $scope.cellWidth)..0]

  $scope.addColumn = -> $scope.columns.push($scope.columns.slice(-1)[0] + 1)

  $scope.removeColumn = -> $scope.columns.pop()

  $scope.addRow = -> $scope.rows.push($scope.rows.slice(-1)[0] - 1)

  $scope.removeRow = -> $scope.rows.pop()

  $scope.bigger = ->
    console.log('Bigger')
    $scope.removeColumn()
    $scope.cellWidth = width / $scope.columns.length
    while $scope.cellWidth * $scope.rows.length >= height
      $scope.removeRow()

  $scope.smaller = ->
    console.log('Smaller')
    $scope.addColumn()
    $scope.cellWidth = width / $scope.columns.length
    while $scope.cellWidth * $scope.rows.length <= height
      $scope.addRow()

  left = 0
  right = 0
  up = 0
  down = 0
  document.addEventListener 'mousewheel', (e) ->
    e.preventDefault()
    # console.log e
    wheelDelta = Math.abs(e.wheelDelta)
    $scope.$apply ->
      $scope.bigger() if e.wheelDelta == -120 && e.wheelDeltaY == -120
      $scope.smaller() if e.wheelDelta == 120 && e.wheelDeltaY == 120
      if e.wheelDeltaX < 0
        left += 1
        if left >= 4
          $scope.left()
          left = 0
      if e.wheelDeltaX > 0
        if wheelDelta < 200
          right += 1
          console.log 'slow'
        else if wheelDelta < 400
          right += 2
          console.log 'medium'
        else if wheelDelta < 600
          right += 4
          console.log 'fast'
        else
          console.log 'very fast'
          right += 6
        if right >= 4
          $scope.right()
          right = 0
        else if right >= 6
          $scope.right()
          $scope.right()
          right = 0
      if e.wheelDeltaY < 0
        console.log 'up'
        up += 1
        if up >= 4
          $scope.up()
          up = 0
      if e.wheelDeltaY > 0
        down += 1
        if down >= 4
          $scope.down()
          down = 0


  ##### Actual game controller #####

  $scope.running = false
  $scope.speed = 150
  $scope.spaceTime = SpaceTimeFactory.new()

  $scope.spaceTime.initialize()

  $scope.resurrect = (x, y) ->
    $scope.spaceTime.presentWorld.set({x: x, y: y}, true)

  $scope.kill = (x, y) ->
    $scope.spaceTime.presentWorld.remove({x: x, y: y})

  $scope.tic = -> $scope.spaceTime.tic()

  $scope.buttonText = 'Start'

  $scope.toggle = ->
    if $scope.running
      $scope.buttonText = 'Start'
      $scope.running = false
    else
      $scope.buttonText = 'Stop'
      $scope.running = true
      $scope.repeat()

  $scope.step = ->
    if $scope.running
      $scope.buttonText = 'Start'
      $scope.running = false
    $scope.tic()

  $scope.repeat = ->
    if $scope.running
      $scope.tic()
      $timeout($scope.repeat, $scope.speed)

  $scope.reset = ->
    $scope.buttonText = 'Start'
    $scope.running = false
    $scope.spaceTime = SpaceTimeFactory.new()

  $scope.cellCount = ->
    $scope.spaceTime.presentWorld.cellCount()

  $scope.worlds = ->
    $scope.spaceTime.worlds
