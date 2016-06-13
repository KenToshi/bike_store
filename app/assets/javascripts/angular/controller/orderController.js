var ok = 0;

myApp.controller('orderController', ['$scope', '$http', function($scope, $http){
    ok = 1;
    
    $scope.sortType     = ''; // set the default sort type
    $scope.sortReverse  = false;  // set the default sort order
    $scope.searchOrder   = '';     // set the default search/filter term
    
    $scope.painting = function(){
        console.log("lala")
        // $(".IsPaid").css("font-color","red");
    }
    
    $http.get(localhost+"/orders.json").then(function(response,status,headers,config){
        
        $scope.orders = response.data;
        console.log($scope.orders);
        
      },function(data,status,headers, config){
      	alert(data+" "+status+" "+headers+" "+config);
      });

}]);      

    setTimeout(function(){ 
        if(ok==0) window.location.reload(true); 
    }, 100);

