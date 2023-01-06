import 'dart:io';

import 'package:dmt/utils/commonview.dart';
import 'package:dmt/utils/constColors.dart';
import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/utils/routes.dart';
import 'package:dmt/utils/sessionMenager.dart';
import 'package:dmt/view/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  String _selectedOpection = ConstLables.oximetryAob;
  late SharedPreferences sharedPreferences;
  // if flage = true then Esign selected other wised connect selected
  bool flag = true;


  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
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

            Card(
              color: Colors.white,
              margin: EdgeInsets.zero,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        child: Image.asset(ConstImagesPath.logo,
                            alignment: Alignment.topCenter)),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        SessionManager(sharedPreferences).clearSession();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(Routes.login,(route) => false);
                      },
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                          child:
                              Container(child: Image.asset(ConstImagesPath.logout)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //             child: InkWell(
            //               onTap: (){},
            //               child: Image.asset(
            //                ConstImagesPath.esign
            //         ),
            //             )),
            //       ),
            //       Expanded(
            //         child: Container(
            //             child: InkWell(
            //               onTap: () async {
            //                 Navigator.pushNamed(context,Routes.deviceConnect);
            //               },
            //               child: Image.asset(
            //                ConstImagesPath.unselected_connect
            //               ),
            //             )),
            //       ),
            //     ],
            //   ),
            // ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: CommonView(context)
                  .titele(ConstLables.needSign , Colors.black),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _selectOpection(ConstLables.oximetryAob, ConstLables.oximetryAob, ConstLables.oxygentesting,ConstImagesPath.oximetryicon),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    height: 1,
                    child: Divider(
                      color: Colors.grey[300],
                    ),
                  ),
                  _selectOpection(ConstLables.homesleep, ConstLables.homesleep, ConstLables.sleepApnea,ConstImagesPath.hst),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    height: 1,
                    child: Divider(
                      color: Colors.grey[300],
                    ),
                  ),
                  _selectOpection(ConstLables.reAob, ConstLables.reAob, ConstLables.clinicianHome,ConstImagesPath.reaob),

                ],
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
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });

                    if(_selectedOpection == ConstLables.oximetryAob) {
                      Navigator.pushNamed(context, Routes.oximetryResultScreen);
                    }else if(_selectedOpection == ConstLables.homesleep){
                      Navigator.pushNamed(context, Routes.homeSleepTestingAob);
                    }else if(_selectedOpection == ConstLables.reAob){
                      Navigator.pushNamed(context, Routes.reAobScreen);
                    }
                  },
                  color: ConstColors.primary,
                  minWidth: double.infinity,
                  height: 40,
                  padding: EdgeInsets.zero,
                  child: Text(
                   ConstLables.next,
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

  Widget _selectOpection(
      String value, String title, String subtitle, String image) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Radio(
          value: value,
          groupValue: _selectedOpection,
          onChanged: (value) {
            setState(() {
              _selectedOpection = value.toString();
            });
          },
        ),
        SizedBox(
            height: 50,
            width: 50,
            child: Image.asset(image)),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(color: ConstColors.title,fontSize: 16,fontWeight: FontWeight.w500),),
              Text("($subtitle)",style: TextStyle(color: ConstColors.subTitle,fontSize: 14,fontWeight: FontWeight.bold),overflow: TextOverflow.clip,),
            ],
          ),
        ),
      ],
    );
  }


}
