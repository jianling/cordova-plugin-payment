/**
 * Alipay、wxpay plugin for Cordova / Phonegap
 */
package com.baidu;


import android.os.Handler;
import android.os.Message;
import android.widget.Toast;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import com.alipay.sdk.app.PayTask;

import java.util.Map;

public class CDVPayment extends CordovaPlugin {

    private Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
//            https://docs.open.alipay.com/204/105302
            Map<String, String> resultObject = (Map<String, String>) msg.obj;
            Toast.makeText(cordova.getActivity(), resultObject.get("memo"),
                    Toast.LENGTH_LONG).show();
        }
    };

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
    }

    @Override
    public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext)
            throws JSONException {
        if (action.equals("alipay")) {
            final String payInfo = args.getString(0);
            Runnable payRunnable = new Runnable() {
                @Override
                public void run() {
                    PayTask alipay = new PayTask(cordova.getActivity());
                    Map<String, String>  result = alipay.payV2(payInfo, true);

                    Message msg = new Message();
                    msg.obj = result;
                    mHandler.sendMessage(msg);
                }
            };

            Thread payThread = new Thread(payRunnable);
            payThread.start();
        }
//        微信支付暂不支持
        else {
            return false;
        }

        return true;
    }

}
