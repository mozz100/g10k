var g10kApp = angular.module('g10kApp', []);

var Runner = function(data) {
	// instance creation here
	this.name = data.name;
	this.startTime = new Date(data.start_time);
};

function getRaceTime(now, startTime) {
	// return the race time (-ve means unstarted)
	// formatted as minutes:seconds.x
	var diff = Math.abs(now - startTime)/1000.0;
	var mins = Math.floor(diff / 60.0);
	var secs = diff - 60.0 * mins;
	return (now < startTime ? '-': '') + mins + ':' + (secs < 10 ? '0': '') + secs.toFixed(1);
}

g10kApp.controller('RunnersCtrl', ['$scope', '$http', function ($scope, $http) {
  	$scope.runners = [];
	$http.get('/race.json').success(function(data) {
		for (var i = 0; i < data.runners.length; i++) {
			var runner = new Runner(data.runners[i]);
    		$scope.runners.push(runner);
		}
    	
  	});
}]);

$(function() {
	setInterval(function() {
		var now = (new Date()).getTime();
		$('.time').each(function(i, ele) {
			var t = $(ele);
			t.text(getRaceTime(now, parseInt(t.attr('data-time'))));
			
		});
	}, 100);
});