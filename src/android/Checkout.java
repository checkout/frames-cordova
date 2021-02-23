package com.checkout.plugin;

import android.content.Context;

import com.android.volley.VolleyError;
import com.checkout.android_sdk.CheckoutAPIClient;
import com.checkout.android_sdk.Request.CardTokenisationRequest;
import com.checkout.android_sdk.Response.CardTokenisationFail;
import com.checkout.android_sdk.Response.CardTokenisationResponse;
import com.checkout.android_sdk.Utils.Environment;
import com.google.gson.Gson;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Checkout extends CordovaPlugin {

    private Context mContext;
    private Gson mGson;

    private CheckoutAPIClient mCheckoutAPIClient;
    private CallbackContext mCallbackContext;

    private final CheckoutAPIClient.OnTokenGenerated mTokenListener = new CheckoutAPIClient.OnTokenGenerated() {
        @Override
        public void onTokenGenerated(CardTokenisationResponse response) {
            try {
                mCallbackContext.success(new JSONObject(mGson.toJson(response)));
            } catch (JSONException e) {
                mCallbackContext.error(e.getLocalizedMessage());
            }
        }

        @Override
        public void onError(CardTokenisationFail error) {
            try {
                mCallbackContext.error(new JSONObject(mGson.toJson(error)));
            } catch (JSONException e) {
                mCallbackContext.error(e.getLocalizedMessage());
            }
        }

        @Override
        public void onNetworkError(VolleyError error) {
            mCallbackContext.error(error.getLocalizedMessage());
        }
    };

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        mContext = webView.getContext();
        mGson = new Gson();
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("initLiveClient")) {
            setupClient(args.getString(0), Environment.LIVE, callbackContext);
        } else if (action.equals("initSandboxClient")) {
            setupClient(args.getString(0), Environment.SANDBOX, callbackContext);
        }  else if (action.equals("generateToken")) {
            generateToken(args.getJSONObject(0), callbackContext);
        } else {
            return false;
        }
        return true;
    }

    private void setupClient(String pubKey, Environment environment, CallbackContext callbackContext) {
        try {
            mCheckoutAPIClient = new CheckoutAPIClient(mContext, pubKey, environment);
            mCheckoutAPIClient.setTokenListener(mTokenListener);
            callbackContext.success();
        } catch (Exception e) {
            callbackContext.error(e.getLocalizedMessage());
        }
    }

    private void generateToken(JSONObject jsonObject, CallbackContext callbackContext) {
        try {
            CardTokenisationRequest dto = mGson.fromJson(jsonObject.toString(), CardTokenisationRequest.class);
            mCheckoutAPIClient.generateToken(dto);
            mCallbackContext = callbackContext;
        } catch (Exception e) {
            callbackContext.error(e.getLocalizedMessage());
        }
    }
}
