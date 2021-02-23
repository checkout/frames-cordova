var exec = require('cordova/exec');

module.exports = {

    initLiveClient: function (pubKey, success, error) {
        exec(success, error, 'Checkout', 'initLiveClient', [pubKey]);
    },

    initSandboxClient: function (pubKey, success, error) {
        exec(success, error, 'Checkout', 'initSandboxClient', [pubKey]);
    },

    generateToken: function (cardTokenisationRequest, success, error) {
        exec(success, error, 'Checkout', 'generateToken', [cardTokenisationRequest]);
    }
};

