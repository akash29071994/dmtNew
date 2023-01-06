import 'dart:async';
import 'dart:convert';

import 'package:dmt/api/api.dart';
import 'package:dmt/api/requestheader.dart';
import 'package:dmt/model/loginResult.dart';
import 'package:flutter/cupertino.dart';

class LoginController{
  BuildContext context;

  LoginController(this.context);

  FutureOr<LoginResult?> loginReqiest(var body) async {
    LoginResult? resultdata=null;
    var res= await ApiRequests(context: context).sendServerRequest(
       Api.login, body);
    if(res != null){
      var data = json.decode(res);
      resultdata = LoginResult.fromJson(data);
    }
    return resultdata;
  }
}
