import 'dart:convert';

import 'package:dmt/api/api.dart';
import 'package:dmt/api/requestheader.dart';
import 'package:dmt/model/hstResults.dart';
import 'package:dmt/model/patientOximetryResults.dart';
import 'package:dmt/model/reaobResult.dart';
import 'package:flutter/cupertino.dart';

class ReAobController{


  Future<ReaobResults?> getData(var body,BuildContext ctx) async {


    ReaobResults? results=null;
    var res= await ApiRequests(context: ctx).sendServerRequest(
        Api.reResults, body);
    if(res != null){
      var data = json.decode(res);
      results = ReaobResults.fromJson(data);
    }
    return results;
    }
}

