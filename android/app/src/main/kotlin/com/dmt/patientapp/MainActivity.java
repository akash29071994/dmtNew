package com.dmt.patientapp;
import android.Manifest;
import android.os.Build;

import androidx.annotation.NonNull;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.vivalnk.sdk.BuildConfig;
import com.vivalnk.sdk.Callback;
import com.vivalnk.sdk.CommandRequest;
import com.vivalnk.sdk.DataReceiveListener;
import com.vivalnk.sdk.VitalClient;
import com.vivalnk.sdk.ble.BluetoothConnectListener;
import com.vivalnk.sdk.ble.BluetoothScanListener;
import com.vivalnk.sdk.command.abpm.ParametersKey;
import com.vivalnk.sdk.command.base.CommandAllType;
import com.vivalnk.sdk.common.ble.connect.BleConnectOptions;
import com.vivalnk.sdk.common.ble.scan.ScanOptions;
import com.vivalnk.sdk.model.Device;
import com.vivalnk.sdk.utils.DateFormat;
import com.vivalnk.sdk.utils.GSON;
import androidx.core.app.ActivityCompat;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity{

    private static final String CHANNEL = "com.dmt.patientapp/device";
    private static final String TAG = "DMT";
    static List<Device> deviceList = new ArrayList<>();
    JSONArray jsonArray=new JSONArray();
    String oximetryid="";
    String studysession="";
    private static final String[] BLE_PERMISSIONS = new String[]{
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION
    };


    private static final String[] ANDROID_12_BLE_PERMISSIONS = new String[]{
            Manifest.permission.BLUETOOTH_SCAN,
            Manifest.permission.BLUETOOTH_CONNECT
    };

    SimpleDateFormat obj = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
    // we create instance of the Date and pass milliseconds to the constructor



    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            Log.e("method",call.method.toString());

                            if (call.method.equals("init")) {
                                Log.e("init method In","init method In");
                                VitalClient.getInstance().init(this.getApplicationContext());
                                if (BuildConfig.DEBUG) {
                                    VitalClient.getInstance().openLog();
                                    VitalClient.getInstance().allowWriteToFile(true);
                                }
                                int requestCode=202;
                                if (Build.VERSION.SDK_INT < 31)
                                    ActivityCompat.requestPermissions(this, ANDROID_12_BLE_PERMISSIONS, requestCode);
                                else
                                    ActivityCompat.requestPermissions(this, BLE_PERMISSIONS, requestCode);
                                startScan();
                                result.success(true);

                            }
                            else if(call.method.equals("connectDevice")){
                                Map<String,String> arg= (Map<String, String>) call.arguments;
                                Log.e("devicesName",call.arguments.toString());

                                Device device = findNearestEcgDevice(deviceList,arg.get("name"));
                                if(device != null){
                                    connectDeviceAndroid(arg.get("name"),device);
                                    openFlashData(device);
                                    int isConnect=checkeIsConnect(device);
//                                    result.success(isConnect);
                                    result.success(true);
                                }else {
                                    result.success(false);
                                }

                            }else if(call.method.equals("isDisconnect")){
                                Map<String,String> arg= (Map<String, String>) call.arguments;
                                Device device = findNearestEcgDevice(deviceList,arg.get("name"));
                                openFlashData(device);
                                VitalClient.getInstance().disconnect(device);
                                result.success(true);
                            }
                            else if(call.method.equals("clearMemory")){
                                Map<String,String> arg= (Map<String, String>) call.arguments;
                                Device device = findNearestEcgDevice(deviceList,arg.get("name"));
                                openFlashData(device);
                                result.success(true);
                            }else if(call.method.equals("sync")){
                                Map<String,String> arg= (Map<String, String>) call.arguments;
                                Device device = findNearestEcgDevice(deviceList,arg.get("name"));
                                if(device != null) {
                                    connectDeviceAndroid(arg.get("name"), device);
                                    openFlashData(device);
                                }
                                jsonArray = new JSONArray();
                                result.success(true);
                            }
                            else if(call.method.equals("getDeviceData")){
                                Map<String,String> arg= (Map<String, String>) call.arguments;
                                oximetryid = arg.get("oximetryid");
                                studysession = arg.get("studysession");
                                result.success(jsonArray.toString());
                            }

                        }
                );
    }

    public void openFlashData(Device device) {
        CommandRequest requestFlash = new CommandRequest.Builder()
                .setTimeout(3000)
                .setType(CommandAllType.flashStreamData_Control)
                .addParam(ParametersKey.KEY_control_open_flash, true)
                .build();
        VitalClient.getInstance().execute(device, requestFlash, new Callback() {
            @Override
            public void onComplete(Map<String, Object> data) {
                Callback.super.onComplete(data);
                Log.d(TAG + "Clear data ",data.toString());
            }

            @Override
            public void onError(int code, String msg) {
                Callback.super.onError(code, msg);
                Log.d(TAG + "Clear data "+code,msg.toString());
            }

            @Override
            public void onCancel() {
                Callback.super.onCancel();
            }
        });
    }

    private int checkeIsConnect(Device device) {
       return VitalClient.getInstance().getConnectStatus(device);
    }

    private void connectDeviceAndroid(String arg,Device device) {

                if (device != null) {
                    Log.d(TAG, "connect to device: " + GSON.toJson(device));
                    BleConnectOptions options = new BleConnectOptions.Builder().setAutoConnect(false).build();
                    VitalClient.getInstance().connect(device, options,
                            new BluetoothConnectListener() {

                                @Override
                                public void onConnected(Device device) {
                                    Log.d(TAG, "onConnected: " + GSON.toJson(device));
                                    VitalClient.getInstance().registerDataReceiver(device, dataReceiveListener);
                                }

                                @Override
                                public void onDeviceReady(Device device) {
                                    Log.d(TAG, "onDeviceReady: " + GSON.toJson(device));
                                }

                                @Override
                                public void onDisconnected(Device device, boolean isForce) {
                                    Log.d(TAG, "onDisconnected: " + GSON.toJson(device));
                                }

                                @Override
                                public void onError(Device device, int code, String msg) {
                                    Log.d(TAG, "onError: code = " + code + ", msg = " + msg );
                                }
                            });

                }
    }



    private void startScan() {
        deviceList = new ArrayList<Device>();
        Log.e("Start scan In","Start scan In");
        VitalClient.getInstance().startScan(new ScanOptions.Builder().build(), new BluetoothScanListener() {
            @Override
            public void onDeviceFound(Device device) {
                deviceList.add(device);
                Log.d(TAG, "find device: " + GSON.toJson(device));
            }
            @Override
            public void onStop() {
                Log.d(TAG, "scan stop, find " + deviceList.size() + " devices");
            }
        });
    }

    private Device findNearestEcgDevice(List<Device> deviceList,String name) {
        Device ret = null;
        for (Device device : deviceList) {
            Log.e("Device","==="+device.getName());
            if (device.getName().equals(name)) {
                if (ret == null || device.getRssi() > ret.getRssi() ) {
                    ret = device;
                }
                break;
            }

        }
        return ret;
    }

    private final DataReceiveListener dataReceiveListener = new DataReceiveListener() {
        @Override
        public void onReceiveData(Device device, Map<String, Object> data) {
          //  Log.d(TAG, "onReceiveData: data = " + GSON.toJson(data));
            if(data != null){
                jsonArray = new JSONArray();
                JSONObject jsonObject=new JSONObject();
                String pulserate=data.containsKey("pr") ? data.get("pr").toString(): "0";
                String spo2=data.containsKey("spo2") ? data.get("spo2").toString() : "0";
                String datetime = "";
               if(data.containsKey("time")){
                   long timeMilli = (long) data.get("time");
                   Date date=new Date(timeMilli);
                   datetime = obj.format(date);
               }
                try {
                    jsonObject.put("oximetryid",oximetryid);
                    jsonObject.put("studysession",studysession);
                    jsonObject.put("datetime",datetime);
                    jsonObject.put("pulserate",pulserate);
                    jsonObject.put("spo2",spo2);

                } catch (JSONException e) {
                    e.printStackTrace();
                }

                jsonArray.put(jsonObject);
            }
        }

        @Override
        public void onBatteryChange(Device device, Map<String, Object> data) {
            Log.d(TAG, "onBatteryChange: data = " + GSON.toJson(data));
        }

        @Override
        public void onDeviceInfoUpdate(Device device, Map<String, Object> data) {
            Log.d(TAG, "onDeviceInfoUpdate: data = " + GSON.toJson(data));
        }

        @Override
        public void onLeadStatusChange(Device device, boolean isLeadOn) {
            Log.d(TAG, "onLeadStatusChange: isLeadOn = " + isLeadOn);
        }

        @Override
        public void onFlashStatusChange(Device device, int remainderFlashBlock) {
            Log.d(TAG, "onFlashStatusChange: remainderFlashBlock = " + remainderFlashBlock);
        }

        @Override
        public void onFlashUploadFinish(Device device) {
            Log.d(TAG, "onFlashUploadFinish: device = " + GSON.toJson(device));
        }
    };

}
