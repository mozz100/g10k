var g10kAdminApp = angular.module('g10kAdminApp', []);

g10kAdminApp.controller('AdminCtrl', ['$scope', '$http', function ($scope, $http) {
    $scope.race = {};
    $scope.checkpoint = {};

    function updateRace() {
        $http.get('/race.json').success(function(data) {
                $scope.race = data;
        });        
    }
    updateRace();

    function doPOST(url, data, callback) {
        $http.post(url, data).success(function(response) {
            $scope.race = response;
            if (callback) { callback(); }
        });
    }

    $scope.startRace = function() {
        var startTime = (new Date()).getTime() / 1000.0;
        doPOST('/runners/start_race', {start_time: startTime}, updateRace);
    }
    $scope.resetRace = function() {
        doPOST('/runners/reset');
    }
    $scope.getCheckPoint = function(runnerId, percent) {
        if (typeof($scope.race.runners) == 'undefined') {
            return false;
        }
        for (var i=0; i < $scope.race.runners.length; i++) {
            var r = $scope.race.runners[i];
            if (r.id == runnerId) {
                for (var j=0; j < r.check_points.length; j++) {
                    if (parseInt(r.check_points[j].percent) >= percent) {
                        return true
                    }
                }
            }
        }
        return false;
    }
    $scope.getStatus = function(runnerId) {
        if (typeof($scope.race.runners) == 'undefined') {
            return "";
        }
        for (var i=0; i < $scope.race.runners.length; i++) {
            var r = $scope.race.runners[i];
            if (r.id == runnerId) { return r.status }
        }
    }

    $scope.submitAction = function() {
        var atTime = (new Date()).getTime() / 1000.0;
        var runnerId = $scope.checkpoint.value.split("|")[0];
        var percent  = $scope.checkpoint.value.split("|")[1];
        console.log(runnerId, percent);
        doPOST('/runners/' + runnerId + '/checkpoint', {percent: percent, check_time: atTime});
    }
}]);