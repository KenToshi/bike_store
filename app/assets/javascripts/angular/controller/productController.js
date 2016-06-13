var ok = 0;
myApp.controller('productController', ['$scope', '$http', function($scope, $http){
  ok = 1;
    
  $scope.title = "Product List";
  $http.get(localhost+"/products.json").then(function(response,status,headers,config){
    $scope.products = response.data;
  },function(data,status,headers, config){
  	alert(data+" "+status+" "+headers+" "+config);
  });
}]);

setTimeout(function(){ 
        console.log("FUCK YOU");
        if(ok==0) window.location.reload(true); 
    }, 100);

