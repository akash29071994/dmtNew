import 'package:dmt/api/api.dart';
import 'package:dmt/controller/reAOBController.dart';
import 'package:dmt/model/reaobResult.dart';
import 'package:dmt/utils/constColors.dart';
import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/utils/routes.dart';
import 'package:dmt/utils/sessionMenager.dart';
import 'package:dmt/view/app_bar.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../utils/commonview.dart';

class ReAobScreen extends StatefulWidget {
  const ReAobScreen({Key? key}) : super(key: key);

  @override
  State<ReAobScreen> createState() => _ReAobScreenState();
}

class _ReAobScreenState extends State<ReAobScreen> {
  late ReAobController _controller = ReAobController();
  List<ReaobResultsData> list = [];
  List<ReaobResultsData> searchList = [];
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonView(context)
                            .titele(ConstLables.reAob, Colors.black),
                        SizedBox(width: 100,),
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
      "limit": 10,
      "offset": 0,
      "patientid": patientid
    };

    print("requestbody = $requestbody");

    ReaobResults? results = await _controller.getData(requestbody, ctx);

    if(results != null){
      print(results!.count.toString());
      list = results!.rows!;
    }else{
      list=[];
    }
    setState(() {
      print("list "+list.length.toString());
      // print(list[0].signed);
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

        if(value == null){
          _getPatientOximetry(context,value.toString());
        }
      },
    );
  }

  // Widget _DataView(ReaobResultsData list) {
  //   return Card(
  //     elevation: 4,
  //     color: ConstColors.cardBg,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(
  //         children: [
  //           _RowData(ConstLables.physician,list.physician!.username),
  //           _RowData(ConstLables.insurance,list.patient!.primaryinsurance),
  //           _RowData(ConstLables.referalDate,stringToDateConvert(data: list.entereddate) ),
  //           _RowData(ConstLables.qualifyingStatus,list.qualifyingstatus),
  //           _RowData(ConstLables.status,list.status ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _DataView(ReaobResultsData list) {
    return Card(
      elevation: 4,
      color: ConstColors.cardBg,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonView(context).cardTitle(ConstLables.physician),
                    CommonView(context).cardValue(list.physician!.username),
                  ],),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonView(context).cardTitle(ConstLables.scheduledDate),
                    CommonView(context).cardValue(list.scheduleddate == null ? "" :stringToDateConvert(data: list.scheduleddate)),
                  ],),

              ],),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonView(context).cardTitle(ConstLables.qualifyingStatus),
                    CommonView(context).cardValue(list.patientstatus),
                  ],),
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
                            ConstLables.fname: list.physician!.username,
                            ConstLables.referencecategory: "re",

                          });
                        }else{
                          await Navigator.of(context).pushNamed(
                              Routes.esignComplete, arguments: {
                            ConstLables.esignId: list.id.toString(),
                            ConstLables.fname: list.physician!.username,
                            ConstLables.referencecategory: Api.npvisit,

                          });
                        }
                        _getPatientOximetry(context,"");
                      },
                      child: Image.asset(
                          list.signed.toLowerCase() == "no" ? ConstImagesPath
                              .esign_pending : ConstImagesPath.esigned,height: 30,),
                    ),
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

}
