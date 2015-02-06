var channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');

channel.createSticky('onCordovaInfoReady');
channel.waitForInitialization('onCordovaInfoReady');

function CardReader() {
    this.available = false;
    var me = this;

    channel.onCordovaReady.subscribe(function () {
        me.initializeCardReader(function () {
            me.available = true;
            channel.onCordovaInfoReady.fire();
        }, function (error) {
            me.available = false;
            utils.alert("[ERROR] Error initializing Cordova: " + error);
        });
    });
}

CardReader.prototype.initializeCardReader = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "ipReader", "initializeCardReader", []);
};

CardReader.prototype.getCardReaderInfo = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "ipReader", "getCardReaderInfo", []);
};

CardReader.prototype.enableLogs = function (successCallback, errorCallback, enableLogsFlag) {
    exec(successCallback, errorCallback, "ipReader", "enableLogs", [enableLogsFlag]);
};

CardReader.prototype.onConnectionState = function (state) {
    utils.alert("connectionState: " + state);
};

CardReader.prototype.onMagneticCardData = function (cardDataObj) {
    utils.alert("onMagneticCardData");
};

CardReader.prototype.onMagneticCardEncryptedData = function (cardDataObj) {
    utils.alert("onMagneticCardEncryptedData: " + cardDataObj.data);
};

module.exports = new CardReader();
