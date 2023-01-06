import 'package:dmt/api/api.dart';
import 'package:dmt/utils/constColors.dart';
import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/utils/routes.dart';
import 'package:dmt/view/app_bar.dart';
import 'package:flutter/material.dart';

import '../controller/patientOximetryController.dart';
import '../model/patientOximetryResults.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../utils/commonview.dart';
import 'package:permission_handler/permission_handler.dart';

class OximetryResultScreen extends StatefulWidget {
  const OximetryResultScreen({Key? key}) : super(key: key);

  @override
  State<OximetryResultScreen> createState() => _OximetryResultScreenState();
}

class _OximetryResultScreenState extends State<OximetryResultScreen> {
  late PatientOximetryController patientOximetryController =
      PatientOximetryController();
  List<PatientOximetry> list = [];
  List<PatientOximetry> searchList = [];
  // if flage = true then Esign selected other wised connect selected
  bool flag = true;

  late SharedPreferences sharedPreferences;

  bool esignCompleted=false;

  TextEditingController _search=TextEditingController();
  var _serachNodae=FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
    _getPatientOximetry(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: ConstColors.bgcolor,
       // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),

              TopAppBar(),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonView(context)
                            .titele(ConstLables.oximetryResult, Colors.black),
                        SizedBox(width: 50,),
                        Flexible(child: TextFieldWidgets(_search,ConstLables.Search,true,_serachNodae))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(ConstLables.eSignCompleted,style: TextStyle(color: ConstColors.primary,fontSize: 16),),
                        Checkbox(value: esignCompleted, onChanged: (value){
                          setState(() {
                            esignCompleted = value!;
                          });
                        })
                      ],
                    )
                  ],
                ),
              ),

              Visibility(
                visible: list.length > 0,
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (ctx,index){
                      return _oximetryDataView(list[index]);
                    }),)


            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getPatientOximetry(BuildContext ctx) async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString(ConstLables.patientid));
    String? patientid =
        await sharedPreferences.getString(ConstLables.patientid);
    var requestbody = {
      "searchString": null,
      "sort": {"column": "createdAt", "order": "DESC"},
      "limit": 0,
      "offset": 0,
      "patientid": patientid
    };

    print("requestbody = $requestbody");

    PatientOximetryResults? results = await patientOximetryController.getPatientOximetry(requestbody, ctx);

    if(results != null){
      print(results!.count.toString());
      list = results.patientOximetry;
    }else{
      list=[];
    }
    setState(() {
      print("list "+list.length.toString());
    });


  }


  Widget TextFieldWidgets(TextEditingController _controler,String hintText,bool editable,FocusNode node) {
    return TextFormField(
      //  focusNode: _otpFocusNode,
      controller: _controler,
      keyboardType: TextInputType.text,
      autofocus: false,
      focusNode: node,
      enabled: editable,
      style: const TextStyle(
        //fontFamily: 'Open Sans',
          fontSize: 14.0,
          color: Colors.black),
      decoration: InputDecoration(
        //  fillColor: Colors.white,
        // filled: true,
        labelStyle: TextStyle(color: Colors.black),
        // labelText: "Password",
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _oximetryDataView(PatientOximetry list) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: ConstColors.cardBg,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  CommonView(context).cardTitle(ConstLables.physician),
                  CommonView(context).cardValue(list.physician.username),
                ],),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  CommonView(context).cardTitle(ConstLables.rxDate),
                  CommonView(context).cardValue(list.rxdate == null ? "" : stringToDateConvert(data: list.rxdate)),
                ],),
              ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () async {
                          sharedPreferences.setString(ConstLables.oximetryid, list.id.toString());
                          sharedPreferences.setString(ConstLables.studysession, "Session 1");



                          bool locationPermission = await Permission.location.isGranted;

                          bool? isShowLocationDisclosure = sharedPreferences.containsKey(ConstLables.locationDisclosure) ? sharedPreferences.getBool(ConstLables.locationDisclosure): false;


                          if(!isShowLocationDisclosure!! || !locationPermission) {

                            await showLocationdisclosure(
                                message: "DMT collects location data to enable Device search even when the app is closed or not in use.",
                                title: "Allow Location Access");
                          }else{
                            Navigator.pushNamed(context,Routes.deviceConnect,);
                          }
                        },
                        child: Image.asset(ConstImagesPath.connectdevice,height: 30,)),
                  ],),
            ],),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonView(context).cardTitle(ConstLables.qualifyingStatus),
                      CommonView(context).cardValue(list.patientstatus),
                    ],),
                ),
                Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  CommonView(context).cardTitle(ConstLables.rxReceived),
                  CommonView(context).cardValue(list.rxreceiveddate == null ? "" : stringToDateConvert(data: list.rxreceiveddate)),
                ],),
              ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () async {
                          if(list.signed.toLowerCase() == "no") {
                            await Navigator.of(context).pushNamed(
                                Routes.eSign, arguments: {
                              ConstLables.esignId: list.id.toString(),
                              ConstLables.fname: list.physician.username,
                              ConstLables.referencecategory: Api.oximetry,
                            });
                          }else{
                            await Navigator.of(context).pushNamed(
                                Routes.esignComplete, arguments: {
                              ConstLables.esignId: list.id.toString(),
                              ConstLables.fname: list.physician.username,
                              ConstLables.referencecategory: Api.oximetry,
                            });
                          }
                          _getPatientOximetry(context);
                        },
                        child: Image.asset(list.signed.toLowerCase() == "no" ? ConstImagesPath.esign_pending: ConstImagesPath.esigned,height: 30,)),
                ],),
            ],),
          ],
        ),
      ),
    );
  }


  String stringToDateConvert({required String data}){
    String recivedData = "";
    try{
      final df = new DateFormat('MM/dd/yyyy');
      if(data.isNotEmpty){
        DateTime parseDate =DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(data);
        recivedData = df.format(parseDate);
      }
    }on Exception catch (_){

    }

    return recivedData;
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
                Navigator.pushNamed(context,Routes.deviceConnect,);
              },
            ),
            TextButton(
              child: const Text('Allow'),
              onPressed: () async {
                Navigator.of(context).pop();
                sharedPreferences.setBool(ConstLables.locationDisclosure,true);
                Navigator.pushNamed(context,Routes.deviceConnect,);
              },
            ),

          ],
        );
      },
    );
  }

}
