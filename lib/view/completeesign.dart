import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:dmt/api/api.dart';
import 'package:dmt/api/requestheader.dart';
import 'package:dmt/utils/commonview.dart';
import 'package:dmt/utils/constColors.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/view/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class CompleteESign extends StatefulWidget {
  const CompleteESign({Key? key}) : super(key: key);

  @override
  State<CompleteESign> createState() => _CompleteESignState();
}

class _CompleteESignState extends State<CompleteESign> {
  late SharedPreferences sharedPreferences;
  Map<String, String>? data;
  // if flage = true then Esign selected other wised connect selected
  bool flag = true;
  bool selectedfromgalary=false;

  TextEditingController _firstName=new TextEditingController();
  final FocusNode _firstNameNode = FocusNode();
  String fName ="";
  String esignId ="";
  String referencecategory ="";
  late File esignFile;
  Uint8List? fileBytes=null;

  String _filename = ConstLables.uploadSignature;

  bool callApi = false;


  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );


  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
    data = CommonView.getArguments(context);
    if (data!.containsKey(ConstLables.esignId)) {
      fName = data![ConstLables.fname]!;
      esignId = data![ConstLables.esignId]!;

      referencecategory = data![ConstLables.referencecategory]!;
      print("esignId  & referencecategory : ");
      print(esignId);
      print(referencecategory);
      print("http://dmtuat.flatworldinfotech.com:8900/api/files/content/"+referencecategory+"/patientSignature/"+esignId);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height + 100,
            color: ConstColors.bgcolor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                ),
                TopAppBar(),

                Visibility(
                    visible: !callApi,
                    child:  Container(
                      //height: double.minPositive,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonView(context)
                              .titele(ConstLables.eSign , Colors.black),
                          TextFieldWidgets(_firstName,fName,true,_firstNameNode),
                          SizedBox(height: 16,),

                          referencecategory.isNotEmpty && esignId.isNotEmpty && referencecategory != "npvisit"?
                            Image.network("http://dmtuat.flatworldinfotech.com:8900/api/files/content/"+referencecategory+"/patientSignature/"+esignId,
                              errorBuilder: (context, exception, stackTrace) {
                                return Center(child: CircularProgressIndicator());
                              },
                              height: 180,
                              width: MediaQuery.of(context).size.width,):
                            Image.network("http://dmtuat.flatworldinfotech.com:8900/api/files/content/re/patientSignature/"+esignId,
                              errorBuilder: (context, exception, stackTrace) {
                                return Center(child: CircularProgressIndicator());
                              },
                              height: 180,
                              width: MediaQuery.of(context).size.width,),

                          // DottedBorder(
                          //   borderType: BorderType.RRect,
                          //   radius: Radius.circular(12),
                          //   padding: EdgeInsets.all(6),
                          //   child: Signature(
                          //     controller: _controller,
                          //     backgroundColor: Colors.white,
                          //     height: 180,
                          //   ),
                          // ),
                          SizedBox(height: 16,),

                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: SizedBox(
                          //         height: 1,
                          //         child: Container(color: Colors.grey,width: double.infinity,),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(8.0),
                          //       child: CommonView(context).titele("OR", Colors.black),
                          //     ),
                          //     Expanded(
                          //       child: SizedBox(
                          //         height: 1,
                          //         child: Container(color: Colors.grey,width: double.infinity,),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // SizedBox(height: 16,),
                          // Row(children: [
                          //   Flexible(
                          //     child: Container(height: 40,
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           crossAxisAlignment: CrossAxisAlignment.start,
                          //           children: [
                          //             Text(_filename,overflow: TextOverflow.clip,
                          //               maxLines: 2,
                          //               style: TextStyle(fontSize: 14,color: ConstColors.primary),),
                          //             SizedBox(height: 5,),
                          //             Divider(
                          //               height: 1,
                          //               color: Colors.grey,
                          //             )
                          //           ],
                          //         )
                          //     ),
                          //   ),
                          //   Container(
                          //     margin: EdgeInsets.only(left: 10),
                          //     child: MaterialButton(
                          //       onPressed: () {
                          //         filepicker();
                          //       },
                          //       elevation: 5.0,
                          //       color: ConstColors.primary,
                          //       minWidth: 120,
                          //       height: 40,
                          //       padding: EdgeInsets.zero,
                          //       child: Text(ConstLables.browse,style: TextStyle(color: Colors.white),),
                          //     ),
                          //   ),
                          // ],),
                          // SizedBox(height: 16,),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     SizedBox(
                          //       height: 24.0,
                          //       width: 24.0,
                          //       child: Checkbox(
                          //         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //         value: selectedfromgalary, onChanged: (value){
                          //         setState(() {
                          //           selectedfromgalary = value!;
                          //         });
                          //       },),
                          //     ),
                          //     SizedBox(width: 10,),
                          //     Expanded(
                          //       child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.start,
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(ConstLables.eSignChekBoxText,style: TextStyle(
                          //             color: ConstColors.gray,
                          //             fontSize: 14,
                          //           ),
                          //             overflow: TextOverflow.clip,
                          //             textAlign: TextAlign.justify,),
                          //         ],),
                          //     )
                          //
                          //   ],
                          // ),
                          // SizedBox(height: 16,),
                          // Container(
                          //   child: MaterialButton(
                          //     onPressed: () {
                          //       checkEsign();
                          //     },
                          //     elevation: 5.0,
                          //     color: ConstColors.primary,
                          //     minWidth: double.infinity,
                          //     height: 40,
                          //     padding: EdgeInsets.zero,
                          //     child: Text(ConstLables.eSign,style: TextStyle(color: Colors.white),),
                          //   ),
                          // ),
                          // SizedBox(height: 16,),
                          Container(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                });

                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity,40),
                                side: BorderSide(width: 1.0, color: ConstColors.primary),

                              ),
                              child: Text(ConstLables.back,style: TextStyle(color: ConstColors.primary),),
                            ),
                          )
                        ],
                      ),)),


                Flexible(
                  child: Visibility(
                    visible: callApi,
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 50,),
                            Text("Please wait e-sign upload....")
                          ],
                        ),
                      ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
         // fontSize: 14.0,
          color: ConstColors.primary),
      decoration: InputDecoration(
        //  fillColor: Colors.white,
        // filled: true,
        contentPadding: EdgeInsets.all(0),

        labelStyle: TextStyle(color: Colors.black),
        // labelText: "Password",
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      textInputAction: TextInputAction.next,
    );
  }

  void checkEsign() async {
    if (!_controller.isEmpty) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(const SnackBar(content: Text('No content')));
      Uint8List? data = await _controller.toPngBytes();
      setState(() {fileBytes = data;});
      checkValidation();
    }else{
      checkValidation();
    }
  }

void filepicker() async{
     bool isread = await Permission.bluetooth.status.isGranted;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,allowedExtensions: ['jpeg', 'jpg', 'png'],);

    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
      File selectedfile = File(file.path.toString());
      fileBytes = selectedfile.readAsBytesSync();
      print(fileBytes);
      _filename = result.files.first.name;
      setState(() {
        fileBytes = selectedfile.readAsBytesSync();
      });

    } else {
      // User canceled the picker
    }
  }

  Future<void> checkValidation() async {
   // print("fileBytes"!);
    //print(fileBytes!.toString());
    if(fileBytes == null || fileBytes!.isEmpty){
      CommonView(context).showMyDialog(message: "Please e-sign or selecet file");
    }else if(!selectedfromgalary){
      CommonView(context).showMyDialog(message: "Please select chexbox");
    }else{
      setState(() {
        callApi = true;
      });


      final tempDir = await getTemporaryDirectory();
      String filname = new DateTime.now().millisecond.toString() + ".jpg";
      final file = await new File('${tempDir.path}/' + filname).create();
      file.writeAsBytesSync(fileBytes!);


      var body = {
        Api.referenceid: esignId,
        Api.referencecategory: referencecategory,
        Api.referencetype: "patientSignature",
        Api.filename: filname,
      };
      print(body);
      var res= await ApiRequests(context: context).uploadEsign(Api.filesupload, body,file).then(
              (value) {
                print("**********"+value.toString());
                if(value as bool){
                  Navigator.of(context).pop();
                  CommonView(context).showMyDialog(message: "E-Sign upload successfully");
                }else{
                  setState(() {
                    callApi = false;
                  });
                  CommonView(context).showMyDialog(message: "Something was wrong");
                }
              });
      // if(res != null){
      //   print(res);
      //   final body = json.decode(res);
      //   print(body['id']);
      // }

    }

    }

  Future<String> _findLocalPath() async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

}


