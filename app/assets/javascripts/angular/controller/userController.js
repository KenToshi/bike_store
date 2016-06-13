var ok =0;
  myApp.controller('userController', ['$scope', '$http', function($scope, $http){
    ok = 1;
    $scope.sortType     = ''; // set the default sort type
    $scope.sortReverse  = false;  // set the default sort order
    $scope.searchUser   = '';     // set the default search/filter term
    
  $scope.title ="Users List";
  $http.get(localhost+"/home/userlist.json").then(function(response,status,headers,config){
    $scope.users = response.data;
  },function(data,status,headers, config){
  	alert(data+" "+status+" "+headers+" "+config);
  });
}]);

setTimeout(function(){ 
    if(ok==0) window.location.reload(true); 
}, 100);
