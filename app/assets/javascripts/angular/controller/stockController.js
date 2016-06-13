var ok = 0;
myApp.controller('stockController', ['$scope', '$http', function($scope, $http){
  ok = 1;
  $scope.title = "Stocks";
  $scope.totalQty = function(){
    
    $scope.sortType     = ''; // set the default sort type
    $scope.sortReverse  = false;  // set the default sort order
    $scope.searchProduct   = '';     // set the default search/filter term
    
  }
  $http.get(localhost+"/stocks.json").then(function(response,status,headers,config){
    $scope.stocks = response.data;
  },function(data,status,headers, config){
  	alert(data+" "+status+" "+headers+" "+config);
  });
}]);

setTimeout(function(){ 
    if(ok==0) window.location.reload(true); 
}, 100);