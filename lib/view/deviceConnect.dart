import 'dart:async';
import 'dart:io';

import 'package:dmt/utils/commonview.dart';
import 'package:dmt/utils/constColors.dart';
import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/utils/routes.dart';
import 'package:dmt/utils/sessionMenager.dart';
import 'package:dmt/view/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceConnect extends StatefulWidget {
  const DeviceConnect({Key? key}) : super(key: key);

  @override
  State<DeviceConnect> createState() => _DeviceConnectState();
}

class _DeviceConnectState extends State<DeviceConnect> {

  late SharedPreferences sharedPreferences;
  late SessionManager sessionManager;
  late Map<Permission, PermissionStatus> statuses;
  List<String> deviceslist = [];
  bool deviceScan = false;
  String _selectedDevices = "";
  bool flag = true;
  Timer? timer;
  bool isIntCall = true;


  static const platform = MethodChannel('com.dmt.patientapp/device');
  late FlutterBluePlus flutterBlue;




  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
    bool? isShowLocationDisclosure = sharedPreferences.containsKey(ConstLables.locationDisclosure) ? sharedPreferences.getBool(ConstLables.locationDisclosure): false;


    if(isShowLocationDisclosure!!){
      statuses = await [
        Permission.location, Permission.storage, Permission.bluetooth,Permission.bluetoothScan,Permission.bluetoothConnect
      ].request();
    }else{
      statuses = await [
         Permission.storage, Permission.bluetooth,Permission.bluetoothScan,Permission.bluetoothConnect
      ].request();
    }



    if(isIntCall) {
      if (Platform.isAndroid) {
        print("Platform.isAndroid.....${Platform.isAndroid}");
        try {
          bool init = await platform.invokeMethod('init', _selectedDevices);
        } on PlatformException catch (e) {
          print("some thing was: '${e.message}'.");
        }
      } else if (Platform.isIOS) {
        try {
          bool init = await platform.invokeMethod('init', _selectedDevices);
        } on PlatformException catch (e) {
          print("some thing was: '${e.message}'.");
        }
      }
      setState(() {
        isIntCall = false;
      });
    }


    flutterBlue = FlutterBluePlus.instance;
    bool blue_permision=await Permission.bluetooth.status.isGranted;
    bool blue_status=await flutterBlue.isOn;

    print(blue_permision.toString());
    print(blue_status.toString());

     if(blue_permision && blue_status){
      // Start scanning
       deviceScaning();
    }else{
     if(Platform.isAndroid){
       if(!blue_status){
         CommonView(context).showMyDialog(message: ConstLables.blue_off_msg);
       }
       if(!blue_permision){
         Map<Permission, PermissionStatus> statuses = await [
           Permission.location,
           Permission.storage,
           Permission.bluetooth,
         ].request();

       }
     }

    }

    timer = Timer.periodic(
        Duration(seconds: 5),
            (Timer t) async {
              flutterBlue = FlutterBluePlus.instance;
              bool blue_permision=await Permission.bluetooth.status.isGranted;
              bool blue_status=await flutterBlue.isOn;
              if(!deviceScan){
                deviceScaning();
              }else{
                timer!.cancel();
              }
            }
            );

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
       // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
            ),
        TopAppBar(),


        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: CommonView(context)
              .titele(ConstLables.needByDevices , Colors.black),),

          Flexible(
            child: Visibility(
                visible: deviceslist.length > 0,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return  Container(
                        decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: deviceslist.length == 1 ? BorderRadius.circular(16)
                            : (index == 0) ? BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
                            :  ((deviceslist.length - 1) == index) ? BorderRadius.only(bottomRight: Radius.circular(16),bottomLeft: Radius.circular(16))
                            : BorderRadius.zero,
                        ),
                    child:_deviceItem(deviceslist[index],index));
                  },
                  itemCount:deviceslist.length),
                ),
          ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.zero,
        color: ConstColors.bgcolor,
        margin: EdgeInsets.all(20.0),
        child: Container(
          child: MaterialButton(
            onPressed: () async {
                // Devices connect code
                setState(() {
                  deviceScan = true;
                });
                if(_selectedDevices.isEmpty){
                  CommonView(context).showMyDialog(message: ConstLables.device_msg);
                }else{
                 // print(_selectedDevices);
                  try{
                   if(Platform.isIOS){
                     await platform.invokeMethod('connectDevice',<String,String>{'name' : _selectedDevices});
                     Navigator.pushNamed(context, Routes.deviceSync,arguments: { ConstLables.device_name : _selectedDevices});
                   } else {
                     var isConnect = await platform.invokeMethod(
                         'connectDevice',
                         <String, String>{'name': _selectedDevices});
                     print("isConnect : ");
                     print(isConnect);
                     if (isConnect == 1 || isConnect == 2 || isConnect) {
                       Navigator.pushNamed(context, Routes.deviceSync,
                           arguments: {
                             ConstLables.device_name: _selectedDevices
                           });
                     } else {
                       setState(() {
                         deviceScan = false;
                       });
                       CommonView(context).showMyDialog(
                           message: "Device not connected,Something was wrong");
                     }
                     print("isConnect $isConnect");
                   }
                  }on Exception catch (_){
                    print("isConnect Catch");
                  }
                }
              },
            color: ConstColors.primary,
            minWidth: double.infinity,
            height: 40,
            padding: EdgeInsets.zero,
            child: Text(
               ConstLables.connect,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
    );
  }


  Widget _deviceItem(String deviceslist,pos) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio(
                value: deviceslist,
                groupValue: _selectedDevices,
                onChanged: (value) {
                  setState(() {
                    _selectedDevices = value.toString();
                  });
                },
              ),
              SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(ConstImagesPath.devices)),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deviceslist,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(),
          ),
        ],
      ),
    );
  }


  showLocationdisclosure({required String message, String title=""}) async {


    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title.isEmpty ? 'Alert' : title),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Deny'),
              onPressed: () async {
                Navigator.of(context).pop();
                sharedPreferences.setBool(ConstLables.locationDisclosure,false);
              },
            ),
            TextButton(
              child: const Text('Allow'),
              onPressed: () async {
                Navigator.of(context).pop();
                sharedPreferences.setBool(ConstLables.locationDisclosure,true);
              },
            ),

          ],
        );
      },
    );
  }


  scan(){
    timer = Timer.periodic(
        Duration(seconds: 5),
            (Timer t) async {
          flutterBlue = FlutterBluePlus.instance;
          bool blue_permision=await Permission.bluetooth.status.isGranted;
          bool blue_status=await flutterBlue.isOn;
          if(!deviceScan){
            deviceScaning();
          }else{
            timer!.cancel();
          }
        }
    );
  }

  Future<void> deviceScaning() async {
    print("deviceScaning");
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {


          if(r.device.name.startsWith("O2")) {
            deviceslist.add(r.device.name);
            deviceslist = deviceslist.toSet().toList();
          }
        print('${r.device.id} found! rssi: TYPE ${r.device.type.name} ');
        print('${r.device.name} found! rssi: ${r.rssi} ');
      }
    });
    setState(() {});
    flutterBlue.stopScan();

    if(deviceslist.length > 0){
      deviceScan = true;
    }
    setState(() {
      print(deviceslist.length.toString());
      deviceslist = deviceslist.toSet().toList();
      print(deviceslist.length.toString());
    });
  }
}
