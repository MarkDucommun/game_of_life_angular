@app = angular.
  module('GameOfLife', ['ngRoute', 'ngResource', 'templates']).
  config ($httpProvider) ->
    # auth_token = document.getElementsByName('csrf-token')[0]['content']
    # $httpProvider.defaults.headers.common['X-CSRF-TOKEN'] = auth_token
