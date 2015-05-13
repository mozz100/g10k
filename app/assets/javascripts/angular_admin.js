var g10kAdminApp = angular.module('g10kAdminApp', []);

g10kAdminApp.controller('AdminCtrl', ['$scope', '$http', function ($scope, $http) {
    $scope.race = {};
    $scope.checkpoint = '';

    $http.get('/race.json').success(function(data) {
            $scope.race = data;
    });

    function doPOST(url, data) {
        $http.post(url, data).success(function(response) {
            $scope.race = response;
        });
    }

    $scope.startRace = function() {
        var startTime = (new Date()).getTime() / 1000.0;
        doPOST('/runners/start_race', {start_time: startTime});
    }
    $scope.resetRace = function() {
        doPOST('/runners/reset');
    }

    $scope.submitAction = function() {
        var atTime = (new Date()).getTime() / 1000.0;
        var runnerId = $scope.checkpoint.split("|")[0];
        var percent  = $scope.checkpoint.split("|")[1];
        console.log(runnerId, percent);
        doPOST('/runners/' + runnerId + '/checkpoint', {percent: percent, check_time: atTime});
    }
}]);