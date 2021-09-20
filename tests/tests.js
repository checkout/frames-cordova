var onSuccess = function (done) {
    return function () {
        expect(true).toBe(true);
        done();
    };
};
var onError = function (done) {
    return function (e) {
        if (e) {
            expect(false).toBe(true, e);
        } else {
            expect(false).toBe(true);
        }
        done();
    };
};
exports.defineAutoTests = function () {

    describe('Frames (cordova.plugins.Checkout)', function () {
        it('should exist', function () {
            expect(cordova.plugins.Checkout).toBeDefined();
        });

        describe('initLiveClient', function () {
            it('should exist', function () {
                expect(cordova.plugins.Checkout.initLiveClient).toBeDefined();
            });
            it('should initialize Plugin in Live mode', function (done) {
                cordova.plugins.Checkout.initSandboxClient("pk_7d395871-0d66-4b62-85b6-8424df78b125",
                    onSuccess(done), onError(done));
            });
        });

        describe('initSandboxClient', function () {
            it('should exist', function () {
                expect(cordova.plugins.Checkout.initSandboxClient).toBeDefined();
            });
            it('should initialize Plugin in Sandbox mode', function (done) {
                cordova.plugins.Checkout.initSandboxClient("pk_test_7d395871-0d66-4b62-85b6-8424df78b125",
                    onSuccess(done), onError(done));
            });
        });

        describe('generateToken', function () {
            it('should exist', function () {
                expect(cordova.plugins.Checkout.generateToken).toBeDefined();
            });
            it('should generate a payment token', function (done) {
                cordova.plugins.Checkout.generateToken(
                    {
                        number: "4543474002249996",
                        cvv: "010",
                        expiryMonth: "08",
                        expiryYear: "2025",
                        billing_address: {
                            country: "FR"
                        }
                    },
                    function (response) {
                        expect(response).toBeDefined();
                        expect(response.token).toBeDefined();
                        done();
                    }, onError(done));
            });
        });

    });

};
