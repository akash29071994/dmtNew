import 'package:dmt/api/api.dart';
import 'package:dmt/controller/loginController.dart';
import 'package:dmt/model/loginResult.dart';
import 'package:dmt/utils/commonview.dart';
import 'package:dmt/utils/constColors.dart';
import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/utils/routes.dart';
import 'package:dmt/utils/sessionMenager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController _firstName=new TextEditingController();
  TextEditingController _lastName=new TextEditingController();
  TextEditingController _dob=new TextEditingController();

  final FocusNode _firstNameNode = FocusNode();
  final FocusNode _lastNameNode = FocusNode();
  final FocusNode _dobNode = FocusNode();

  bool isLoading = false;

  late LoginController loginController;
  late LoginResult? result;

  late SharedPreferences sharedPreferences;
  late SessionManager sessionManager;

  late Map<Permission, PermissionStatus> statuses;


  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
    sessionManager=SessionManager(sharedPreferences);

    // bool locationPermission = await Permission.location.isGranted;
    // print(locationPermission);
    // if(!sharedPreferences.containsKey(ConstLables.locationDisclosure) || !locationPermission) {
    //
    //   showLocationdisclosure(
    //       message: "DMT collects location data to enable Device search even when the app is closed or not in use.",
    //       title: "Allow Location Access");
    // }

  }

  @override
  Widget build(BuildContext context) {
    loginController= LoginController(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        color: ConstColors.bgcolor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 32.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(child: Image.asset(ConstImagesPath.logo,alignment: Alignment.topCenter)),
                Container(child: Column(
                  children: [
                    CommonView(context).titele(ConstLables.login,Colors.black),
                    SizedBox(height: 20,),
                    Row(children: [
                      Icon(Icons.perm_identity_rounded,size: 24,color: Colors.grey,),
                      SizedBox(width: 10,),
                      Flexible(child: TextFieldWidgets(_firstName,ConstLables.firstname,true,_firstNameNode))
                    ],),

                    Row(children: [
                      Icon(Icons.perm_identity_rounded,size: 24,color: Colors.grey,),
                      SizedBox(width: 10,),
                      Flexible(child: TextFieldWidgets(_lastName,ConstLables.lastname,true,_lastNameNode))
                    ],),

                    InkWell(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: Row(children: [
                        Icon(Icons.calendar_today_outlined,size: 20,color: Colors.grey,),
                        SizedBox(width: 10,),
                        Flexible(child: TextFieldWidgets(_dob,ConstLables.dob,false,_dobNode))
                      ],),
                    ),
                  ],
                )),



                isLoading ? CircularProgressIndicator() : Container(
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      _checkValidation();
                    },
                    color: ConstColors.primary,
                    minWidth: double.infinity,
                    height: 40,
                    padding: EdgeInsets.zero,
                    child: Text(ConstLables.login,style: TextStyle(color: Colors.white),),
                  ),
                ),





              //  TextFieldWidgets(_lastName,Icons.perm_identity_rounded,ConstLables.lastname),
               // TextFieldWidgets(_dob,Icons.calendar_today_outlined,ConstLables.dob),


          ]),
        ),
      ),


      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: InkWell(
          onTap: (){
            _launchUrl();
          },
          child: Text("Privacy Policy",style: TextStyle(color: Colors.black),textAlign: TextAlign.center),),
      ),


    );
  }

  Future<void> _launchUrl() async {
    String url="https://dmt-idtf.com/Privacy.html";
    if (await canLaunchUrl(Uri.parse(url))) {
      //await launch(url, forceSafariVC: true, forceWebView: true);
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }

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


  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    DateTime currentDate = DateTime.now();
    final df = new DateFormat('MM/dd/yyyy');
    final DateTime? picked = await showDatePicker(
      context: context,
      //initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate:DateTime(currentDate.year, currentDate.month, currentDate.day),
      firstDate: DateTime(1900, currentDate.month, currentDate.day),
      lastDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
    );

    if (picked != null){
      selectedDate = picked;
      _dob.text = df.format(selectedDate);
    }
  }

  Future<void> _checkValidation() async {
    String fristname = _firstName.text.toString();
    String lastName = _lastName.text.toString();
    String dob = _dob.text.toString();

    if(fristname.isEmpty){
      _firstNameNode.requestFocus();
      _closeLoading();
    }else if(lastName.isEmpty){
      _lastNameNode.requestFocus();
      _closeLoading();
    }else if(dob.isEmpty){
      _dobNode.requestFocus();
      _closeLoading();
    }else{
      var body={
        Api.firstname : fristname,
        Api.lastname : lastName,
        Api.dob : dob,
      };

     LoginResult? result=await loginController.loginReqiest(body);
     _closeLoading();
     if(result != null){
       print("Login response"+result.status);
       if(result.status == "failure"){
         CommonView(context).showMyDialog(message: result.message);
       }else{
         LoginResponse response=result.data;
         if(response != null){
          
           sessionManager.setStringData(ConstLables.fname,response.firstname);
           sessionManager.setStringData(ConstLables.lname,response.lastname);
           sessionManager.setStringData(ConstLables.dobkey,response.dob);
           sessionManager.setStringData(ConstLables.isLogin,"true");
           sessionManager.setStringData(ConstLables.patientid,response.patientid.toString());

           Navigator.of(context)
               .pushNamedAndRemoveUntil(Routes.home,(route) => false);

         }else{
           CommonView(context).showMyDialog(message: ConstLables.errorMsg);
         }

       }
     }else{
       _closeLoading();
     }
    }

  }

  void _closeLoading() {
    setState(() {
      isLoading = false;
    });
  }


  showLocationdisclosure({required String message, String title=""}) async {

    sessionManager.setStringData(ConstLables.locationDisclosure,"true");
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
              },
            ),
            TextButton(
              child: const Text('Allow'),
              onPressed: () async {
                Navigator.of(context).pop();
                statuses = await [
                  Permission.location, Permission.storage, Permission.bluetooth,Permission.bluetoothScan,Permission.bluetoothConnect
                ].request();
              },
            ),

          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dob.dispose();
    _dobNode.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _firstName.dispose();
    _lastName.dispose();
  }
}
