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
function formatMinsSecs(s, dp) {
    if (typeof dp === 'undefined') { dp = 0; }
    if (s  === null) { return ''; }
    var sign = s < 0 ? '-':'';
    var absduration = Math.abs(s);
    var mins = Math.floor(absduration / 60.0);
    var secs = absduration - 60.0 * mins;
    return sign + mins + ':' + (secs < 9.99 ? '0': '') + secs.toFixed(dp);
}

angular.module('g10kFilters', []).filter('displayTime', function() {
  return function(input) {
    return formatMinsSecs(input);
  };
});

var g10kApp = angular.module('g10kApp', ['g10kFilters']);

var Runner = function(data) {
    // instance creation here
    this.name = data.name;
    this.startTime = new Date(data.start_time);
    this.nominatedDuration = data.expected_duration;
    this.expectedFinishTime = new Date(data.expected_finish_time);
    this.predictedDuration = (this.expectedFinishTime - this.startTime)/1000;
    this.deltaPrediction = this.predictedDuration - this.nominatedDuration;
    this.status = data.status;
    if (data.actual_finish_time === null) {
        this.actualFinishTime = null;
        this.actualDuration = null;
        this.deltaActual = null;
    } else {
        this.actualFinishTime = new Date(data.actual_finish_time);    
        this.actualDuration = (this.actualFinishTime - this.startTime)/1000;
        this.deltaActual = this.actualDuration - this.nominatedDuration;
    }
    

};

function getRaceTimeDisplay(now, startTime) {
    // return the race time (-ve means unstarted)
    // formatted as minutes:seconds.x
    var diff = (now - startTime)/1000.0;
    return formatMinsSecs(diff, 1);
}

g10kApp.controller('RunnersCtrl', ['$scope', '$http', '$interval', function ($scope, $http, $interval) {
    $scope.runners = [];
    $scope.race = {};
    $scope.sortProp = 'nominatedDuration';
    $scope.reversed = false;

    $scope.getPredicate = function() {
        return ($scope.reversed ? '-':'') + $scope.sortProp;
    }
    $scope.predicate = $scope.getPredicate();

    function refreshData() {
        $http.get('/race.json').success(function(data) {
            $scope.runners = [];
            $scope.race = data;
            for (var i = 0; i < data.runners.length; i++) {
                var runner = new Runner(data.runners[i]);
                $scope.runners.push(runner);
            }
        });         
    }
    refreshData();
    $interval(refreshData, 10 * 1000);

    $scope.sortBy = function(what) {
        if ($scope.sortProp == what) {
            $scope.reversed = !$scope.reversed;
        } else {
            $scope.reversed = false;
        }
        $scope.sortProp = what;
        $scope.predicate = $scope.getPredicate();
    }
}]);

$(function() {
    setInterval(function() {
        var now = (new Date()).getTime();
        $('.time-live').each(function(i, ele) {
            var t = $(ele);
            t.text(getRaceTimeDisplay(now, parseInt(t.attr('data-time'))));
            
        });
    }, 100);
});
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

