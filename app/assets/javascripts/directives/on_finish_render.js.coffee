@app.directive 'onFinishRender', ($timeout) ->
  restrict: 'A'
  link: (scope, element, attr) ->
    if scope.$last == true
      $timeout -> scope.$emit('ngRepeatFinished')
