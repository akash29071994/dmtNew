import 'package:dmt/api/api.dart';
import 'package:dmt/controller/homeSleepTestController.dart';
import 'package:dmt/model/hstResults.dart';
import 'package:dmt/utils/constColors.dart';
import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/utils/routes.dart';
import 'package:dmt/utils/sessionMenager.dart';
import 'package:dmt/view/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import '../utils/commonview.dart';

class HomeSleepTestingAob extends StatefulWidget {
  const HomeSleepTestingAob({Key? key}) : super(key: key);

  @override
  State<HomeSleepTestingAob> createState() => _HomeSleepTestingAobState();
}

class _HomeSleepTestingAobState extends State<HomeSleepTestingAob> {
  late HomeSleepTestController _controller = HomeSleepTestController();
  List<HstResultsData> list = [];
  List<HstResultsData> searchList = [];
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getPatientOximetry(context,"");
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
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonView(context)
                            .titele(ConstLables.homesleep, Colors.black),
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
                      return _DataView(list[index]);
                    }),)


            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getPatientOximetry(BuildContext ctx,String data) async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString(ConstLables.patientid));
    String? patientid =
        await sharedPreferences.getString(ConstLables.patientid);
    var requestbody = {
      "searchString": data,
      "sort": {"column": "createdAt", "order": "DESC"},
      "limit": 0,
      "offset": 0,
      "patientid": patientid
    };

    print("requestbody = $requestbody");

    HstResults? results = await _controller.getHtsData(requestbody, ctx);

    if(results != null){
      print(results!.count.toString());
      list = results!.rows!;
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
      onChanged: (value) {
        if(value != null && value.length == 3){
          _getPatientOximetry(context,value.toString());
        }

        if(value.isEmpty){
          _getPatientOximetry(context,value.toString());
        }
      },
    );
  }

  // Widget _DataView(HstResultsData list) {
  //   return Card(
  //     elevation: 4,
  //     color: Colors.white,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         children: [
  //           _RowData(ConstLables.physician,list.hstofficeuse!.orderingphysician!.username),
  //           _RowData(ConstLables.insurance,list.patient!.primaryinsurance),
  //           _RowData(ConstLables.referalDate,stringToDateConvert(data: list.hstofficeuse!.referralreceiveddate) ),
  //           _RowData(ConstLables.interpretDate,stringToDateConvert(data: list.hstofficeuse!.interpretdate) ),
  //           _RowData(ConstLables.status,list.status ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  Widget _DataView(HstResultsData list) {
    return Card(
      elevation: 4,
      color: ConstColors.cardBg,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      CommonView(context).cardValue(list.hstofficeuse!.orderingphysician!.username),
                    ],),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonView(context).cardTitle(ConstLables.shippedDate),
                      CommonView(context).cardValue(list.hstofficeuse!.referralreceiveddate == null ? "":
                      stringToDateConvert(data: list.hstofficeuse!.referralreceiveddate)),
                    ],),
                ),
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
                      CommonView(context).cardTitle(ConstLables.insurance),
                      CommonView(context).cardValue(list.patient!.primaryinsurance),
                    ],),
                ),

                Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CommonView(context).cardTitle(ConstLables.returnDate),
                            CommonView(context).cardValue(list.hstofficeuse!.returndate == null ? "" :stringToDateConvert(data: list.hstofficeuse!.returndate),),
                          ],),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap : () async {
                                if(list.signed.toLowerCase() == "no") {
                                  await Navigator.of(context).pushNamed(
                                      Routes.eSign, arguments: {
                                    ConstLables.esignId: list.id.toString(),
                                    ConstLables.fname: list.hstofficeuse!
                                        .orderingphysician!.username,
                                    ConstLables.referencecategory: Api.hst,

                                  });
                                }else{
                                  await Navigator.of(context).pushNamed(
                                      Routes.esignComplete, arguments: {
                                    ConstLables.esignId: list.id.toString(),
                                    ConstLables.fname: list.hstofficeuse!
                                        .orderingphysician!.username,
                                    ConstLables.referencecategory: Api.hst,

                                  });
                                }
                                _getPatientOximetry(context,"");
                              },
                              child: Image.asset(
                                list.signed.toLowerCase() == "no" ? ConstImagesPath
                                    .esign_pending : ConstImagesPath.esigned,height: 30,),
                            ),
                          ],),
                      ],
                    ))


              ],),
          ],
        ),
      ),
    );
  }
  _RowData(String title,String value){

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2 ,child: CommonView(context).cardTitle(title )),
        Expanded(flex: 3 ,child: CommonView(context).cardValue(" :  "+value),),
      ],
    );
  }


  String stringToDateConvert({required String data}){
     String recivedData = "";
     final df = new DateFormat('MM/dd/yyyy');
     if(data.isNotEmpty){
       DateTime parseDate =DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(data);
       recivedData = df.format(parseDate);
     }
     return recivedData;
  }
}
