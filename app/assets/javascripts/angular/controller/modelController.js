var ok = 0;
myApp.controller('modelController', ['$scope', '$http', function($scope, $http){
    ok = 1;
    $scope.sortType     = ''; // set the default sort type
    $scope.sortReverse  = false;  // set the default sort order
    $scope.searchModel   = '';     // set the default search/filter term
    
  $scope.title = "Model List";
  $http.get(localhost+"/bike_models.json").then(function(response,status,headers,config){
    $scope.bike_models = response.data;
  },function(data,status,headers, config){
  	alert(data+" "+status+" "+headers+" "+config);
  });
}]);

setTimeout(function(){ 
    if(ok==0) window.location.reload(true); 
}, 100);