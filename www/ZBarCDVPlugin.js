var ZBarCDVPlugin = {
    showZbar: function (resultCallback, cancelCallback, errorCallback) {
        cordova.exec(function (arg) {
            if (arg == null) {
                cancelCallback();
            } else {
                resultCallback(arg);
            }
        }, errorCallback, "ZBarCDVPlugin", "showZbar", []);
    }

};

module.exports = ZBarCDVPlugin;