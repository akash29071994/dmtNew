import 'package:dmt/utils/constColors.dart';
import 'package:flutter/material.dart';

class CommonView{
  BuildContext context;
  CommonView(this.context);



  Widget titele(String title,Color color){
    return Text(
      title,
      style: TextStyle(color: color,fontWeight: FontWeight.bold,fontSize: 16),
    );
  }

  Future<void> showMyDialog({required String message, String title=""}) async {
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
              child: const Text('okay'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  static getArguments(BuildContext context) {
    /* if use this function then pass only message without context in showToast (if use) */
    return ModalRoute.of(context)!.settings.arguments;
  }

  Widget cardTitle(String title,{TextAlign textAlign=TextAlign.start}){
    return Text(
      title,
      style: TextStyle(color: ConstColors.cardTitle,fontWeight: FontWeight.bold,fontSize: 12,),
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
    );
  }

  Widget cardValue(String title,{TextAlign textAlign=TextAlign.start}){
    return Text(
      title,
      style: TextStyle(color: ConstColors.cardValue,fontWeight: FontWeight.bold,fontSize: 14),
      overflow: TextOverflow.clip,
      textAlign: TextAlign.start,
    );
  }


}