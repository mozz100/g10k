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
};

Runner.prototype.getPredictedDuration = function() {
    return (this.expectedFinishTime - this.startTime)/1000;
}

Runner.prototype.getDeltaPrediction = function() {
    // predicted duration - nominated duration
    return this.getPredictedDuration() - this.nominatedDuration;
}

Runner.prototype.getDeltaActual = function() {
    // predicted duration - nominated duration
    return null;
}

function getRaceTimeDisplay(now, startTime) {
    // return the race time (-ve means unstarted)
    // formatted as minutes:seconds.x
    var diff = (now - startTime)/1000.0;
    return formatMinsSecs(diff, 1);
}

g10kApp.controller('RunnersCtrl', ['$scope', '$http', '$interval', function ($scope, $http, $interval) {
    $scope.runners = [];

    function refreshData() {
        $http.get('http://docker:8080/race.json').success(function(data) {
            $scope.runners = [];
            for (var i = 0; i < data.runners.length; i++) {
                var runner = new Runner(data.runners[i]);
                $scope.runners.push(runner);
            }
        });         
    }
    refreshData();
    $interval(refreshData, 10 * 1000);
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