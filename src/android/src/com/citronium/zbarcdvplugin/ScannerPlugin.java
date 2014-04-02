package com.citronium.zbarcdvplugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;
import android.app.Activity;
import android.content.Intent;

/**
 * This class echoes a string called from JavaScript.
 */
public class ScannerPlugin extends CordovaPlugin {
    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("scan")) {
            //String message = args.getString(0);
            //this.echo(message, callbackContext);

            Intent intent = new Intent(this.cordova.getActivity(), ScannerActivity.class);
            this.cordova.getActivity().startActivity(intent);

            return true;
        }
        return false;
    }

    /*private void echo(String message, CallbackContext callbackContext) {
        if (message != null && message.length() > 0) {
            callbackContext.success(message);
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }

        //this.cordova.getActivity().startActivity(calIntent);
    } */
}