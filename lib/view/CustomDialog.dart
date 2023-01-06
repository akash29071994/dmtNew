import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description;


  CustomDialog({
    required this.title,
    required this.description,
  });



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }


  dialogContent(BuildContext context) {

    Future.delayed(const Duration(seconds: 2),
    () {
      Navigator.pop(context);
    });
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: 64,
            bottom: 16,
            left: 16,
            right: 16,
          ),
          margin: EdgeInsets.only(top: 32),
          width: double.infinity,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffEE0073),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffEE0073),
                ),
              ),
              SizedBox(height: 24.0),

            ],
          ),
        ),

        Positioned(
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 32,
            child: Center(child: Icon(Icons.check,size: 32,color: Colors.white,),)
          ),
        ),
      ],
    );
  }
}