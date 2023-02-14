var exec = require('cordova/exec');

module.exports = {
    wswScreenAd:function (arg0, success, error) {
        exec(success, error, 'wswAdWork', 'wswScreenAd', [arg0]);
    },
	wswIncentiveAd:function (arg0, success, error) {
	    exec(success, error, 'wswAdWork', 'wswIncentiveAd', [arg0]);
	},
}
