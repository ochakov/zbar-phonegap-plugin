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
public class ZBarCDVPlugin extends CordovaPlugin {
    private CallbackContext mCallbackContext;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        mCallbackContext = callbackContext;
        if (action.equals("showZbar")) {
            Context applicationContext = this.cordova.getActivity().getApplicationContext();
            Intent intent = new Intent(applicationContext, ScannerActivity.class);
            this.cordova.startActivityForResult(this, intent, ScannerActivity.REQUEST_CODE);

            return true;
        }
        return false;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (data == null) {return;}
        String name = data.getStringExtra("name");
        mCallbackContext.success(name);
    }
}