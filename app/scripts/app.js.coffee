angular.module("app", []).config ($routeProvider) ->
  $routeProvider.when("/",
    templateUrl: "main.html"
    controller: "MainCtrl"
  ).otherwise redirectTo: "/"
