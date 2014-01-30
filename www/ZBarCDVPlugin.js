var argscheck = require('cordova/argscheck'),
    channel = require('cordova/channel'),
    utils = require('cordova/utils'),
    exec = require('cordova/exec'),
    cordova = require('cordova');
              
 function ZBarCDVPlugin() {
    this.results = [];
    this.resCallback = null;
    this.errorCallback = null;
    this.cancelCallback = null;
    
}


ZBarCDVPlugin.prototype.showZbar = function(resultCallback, cancelCallback, errorCallback) {
    this.results = [];
    this.resCallback = resultCallback;
    this.cancelCallback = cancelCallback;
    this.errorCallback = errorCallback;
    exec(null, errorCallback, "ZBarCDVPlugin", "showZbar", []);
};

ZBarCDVPlugin.prototype.getResult = function() {
    return this.results;
};

ZBarCDVPlugin.prototype.addResult = function(data) {
    this.results.push(data);
};

ZBarCDVPlugin.prototype.resultCallback = function(data) {
    if (this.resCallback) {
        this.resCallback(this.results);
    }
};

ZBarCDVPlugin.prototype.cancelCallback = function(data) {
    if (this.cancelCallback) {
        this.cancelCallback();
    }
};

ZBarCDVPlugin.prototype.failCallback = function(data) {
    if (this.errorCallback) {
        this.errorCallback();
    }
};

module.exports = new ZBarCDVPlugin();
