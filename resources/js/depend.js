/**
 * 
 */
angular.module('MyApp').factory('myhttpserv', function ($http) {
  	return {http : $http({url : '/ermsweb/empDetails', type: "json", method:'GET', header:'Content-Type: application/json' })}
});