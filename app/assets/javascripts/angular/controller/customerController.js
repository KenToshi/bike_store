var ok = 0;
myApp.controller('customerController', ['$scope', '$http', function($scope, $http){
    ok = 1;
    $scope.sortType     = ''; // set the default sort type
    $scope.sortReverse  = false;  // set the default sort order
    $scope.searchCustomer   = '';     // set the default search/filter term
    
  $scope.title = "Customer List";
  $http.get(localhost+"/customers.json").then(function(response,status,headers,config){
    $scope.customers = response.data;
  },function(data,status,headers, config){
  	alert(data+" "+status+" "+headers+" "+config);
  });
}]);

setTimeout(function(){ 
    if(ok==0) window.location.reload(true); 
}, 100);

