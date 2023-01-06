import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dmt/controller/patientOximetryController.dart';
import 'package:dmt/model/deviceSyncResult.dart';
import 'package:dmt/utils/commonview.dart';
import 'package:dmt/utils/constColors.dart';
import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/utils/routes.dart';
import 'package:dmt/utils/sessionMenager.dart';
import 'package:dmt/view/CustomDialog.dart';
import 'package:dmt/view/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DeviceSync extends StatefulWidget {
  const DeviceSync({Key? key}) : super(key: key);

  @override
  State<DeviceSync> createState() => _DeviceSyncState();
}

class _DeviceSyncState extends State<DeviceSync> {
  PatientOximetryController patientOximetryController = PatientOximetryController();
  Map<String, String>? data;
  late SharedPreferences sharedPreferences;
  List<String> deviceslist = [];
  bool sendData = false;
  String _selectedDevices = "";
  String oximetryid = "";
  String studysession = "Session1";
  bool flag = true;
  DateFormat format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");


  static const platform = MethodChannel('com.dmt.patientapp/device');
  Timer? timer;
  late FlutterBluePlus flutterBlue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendData = false;
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
    data = CommonView.getArguments(context);
    if (data!.containsKey(ConstLables.device_name)) {
      _selectedDevices = data![ConstLables.device_name]!;
    }
    oximetryid = sharedPreferences.getString(ConstLables.oximetryid)!;
    setState(() {
      
    });

  }
    @override
    void dispose() {
      // TODO: implement dispose
      timer!.cancel();
      super.dispose();

    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ConstColors.bgcolor,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
            TopAppBar(),
            Container(

              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                        child: InkWell(
                          onTap: (){
                            platform.invokeMethod('isDisconnect',<String,String>{'name' : _selectedDevices});
                            Navigator.pushNamed(context, Routes.home);
                          },
                          child: Image.asset(
                            ConstImagesPath.unselect_esign,
                          ),
                        )),
                  ),
                  Expanded(
                    child: Container(
                        child: InkWell(
                          onTap: () async {
                           // Navigator.pushNamed(context,Routes.deviceConnect);
                          },
                          child: Image.asset(
                            ConstImagesPath.connect_btn,
                          ),
                        )),
                  ),
                ],
              ),
            ),

            sendData ?
            Expanded(child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      ConstImagesPath.syncing,
                      height: 125.0,
                      width: 125.0,
                    ),
                SizedBox(height: 50,),
                Container(
                  child: MaterialButton(
                    onPressed: () async {
                      stopDataSend();
                      platform.invokeMethod('isDisconnect',<String,String>{'name' : _selectedDevices});
                      setState(() {
                        sendData = false;
                      });
                      showDialogMessage("Data Sync is ","Successful");
                    },
                    color: Color(0xffEE0073),
                    height: 40,
                    minWidth: 200,
                    //padding: EdgeInsets.zero,
                    child: Text(
                      ConstLables.stop,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ]),
            )) : Expanded(child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: MaterialButton(
                        onPressed: () async {
                          print("_selectedDevices $_selectedDevices");

                           // await platform.invokeMethod('connectDevice',<String,String>{'name' : _selectedDevices});
                            await platform.invokeMethod('sync',<String,String>{'name' : _selectedDevices});
                          startDataCollect(oximetryid);
                          setState(() {
                              sendData = true;
                          });
                        },
                        color: Color(0xffEE0073),
                        height: 40,
                        minWidth: 200,
                        //padding: EdgeInsets.zero,
                        child: Text(
                          ConstLables.sync,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    Container(
                      child: MaterialButton(
                        onPressed: () async {
                          platform.invokeMethod('clearMemory',<String,String>{'name' : _selectedDevices});
                          showDialogMessage("Cleared","Memory");
                        },
                        color: Color(0xffF2F2F2),
                        height: 40,
                        // padding: EdgeInsets.zero,
                        minWidth: 200,
                        child: Text(
                          ConstLables.clearMemory,
                          style: TextStyle(
                              color: Color(0xffEE0073),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ]),
            ))



          ],
        ),
      ),


    );
  }

  startDataCollect(String oximetryid){
    timer = Timer.periodic(
          Duration(seconds: 3),
              (Timer t) => deviceSendToServer(oximetryid));
    }


  stopDataSend(){
    if(timer != null){
      timer!.cancel();
    }
  }

  Future<void> deviceSendToServer(String oximetryid) async {
    var requestbody = await platform.invokeMethod("getDeviceData",<String,String>{'oximetryid' : oximetryid, 'studysession': studysession});
   // var jsonBody=jsonEncode(requestbody);
    print("requestbody ${requestbody.toString()}");

    var results = await patientOximetryController.sendDeviceToServer(requestbody, context);
    if(results != null){
      print("res   "+results.toString());

    }else{

    }
  }


  showDialogMessage(String title,String description){
     return showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        description: description,
      ),
    );
  }

}
