import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dmt/api/api.dart';
import '../utils/commonview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path/path.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';




class ApiRequests{
  final BuildContext context;
  ApiRequests({required this.context});


  Future<dynamic> sendServerRequest(String apiName,var body)async{

    final bool isConnected = await InternetConnectionChecker().hasConnection;

    if (isConnected) {
      var client = http.Client();
      try {
        var url = Uri.parse(apiName);
        print(url);
        var jsonBody = "";
        if(body.toString().startsWith("[")){
          if(Platform.isAndroid){
            jsonBody = body;
          }
          if(Platform.isIOS){
            jsonBody=jsonEncode(body);
          }

        }else{
          jsonBody=jsonEncode(body);
        }

        print(jsonBody);
        try {
          var response = await http.post(url, body: jsonBody,headers: {"Content-Type": "application/json"})
              .timeout(Duration(seconds: 60));
          print(response.body);
          return response.body;
        }on TimeoutException catch (_) {
          CommonView(context).showMyDialog(message: "server not responding",title: "Issue");
        } on SocketException catch (_) {
          // Other exception
          CommonView(context).showMyDialog(message: "server not responding",title: "Issue");
        }
        return null;
      } finally {
        client.close();
      }
    }else{
      // hideDialog();
      print('not connected');
      CommonView(context).showMyDialog(message: "Please connect to internet",title: "Internet Issue");
    }
  }





  Future<bool> uploadEsign(String apiName,Map<String,String> body,File esign) async {

    final bool isConnected = await InternetConnectionChecker().hasConnection;

    bool issuccess = false;
    if (isConnected) {
      // showLodingDialog();
      print(body);
      var url = Uri.parse(apiName);
      http.MultipartRequest request = new http.MultipartRequest('POST', url);
      request.fields[Api.referenceid] = body[Api.referenceid] ?? "0";
      request.fields[Api.referencecategory] = body[Api.referencecategory] ?? "0";
      request.fields[Api.referencetype] = body[Api.referencetype] ?? "0";
      request.fields[Api.filename] = body[Api.filename] ?? "0";
      request.fields[Api.filetype] = "image/jpeg";
      request.fields[Api.allowmultiple] = "false";



      File imageFile = File(esign.path.toString());
      var stream =  http.ByteStream(imageFile.openRead());
      stream.cast();
      var length = await imageFile.length();
      MultipartFile multipartFile = new http.MultipartFile("file", stream, length, filename: basename(imageFile.path));
      request.files.add(multipartFile);

      print("request" + request.fields.toString());
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Image Uploaded");
        String esignUpload="";
        await response.stream.transform(utf8.decoder).listen((value) async {
          print("response  $value");
          esignUpload = value;});
        print("esignUpload  $esignUpload");
        if(esignUpload.contains('file stored')){

          var url = Uri.parse(Api.updatesigned + body[Api.referenceid].toString());
          var bodyrequet = {
            "id" : body[Api.referenceid],
            "signed" : "yes",
            "type": body[Api.referencecategory]
          };
          var response = await http.patch(url,
              body: bodyrequet)
              .timeout(Duration(seconds: 60));
          print("update  "+response.body);
          issuccess = true;
        }
        return issuccess;
      } else {
        print("Upload Failed");
        return issuccess;
      }

    }else{
      print('not connected');
      CommonView(context).showMyDialog(message: "Please connect to internet",title: "Internet Issue");
    }

    return issuccess;

}


}