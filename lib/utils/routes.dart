import 'package:dmt/view/completeesign.dart';
import 'package:dmt/view/deviceConnect.dart';
import 'package:dmt/view/deviceSync.dart';
import 'package:dmt/view/esign.dart';
import 'package:dmt/view/homeScreen.dart';
import 'package:dmt/view/home_sleep_test_aob.dart';
import 'package:dmt/view/login.dart';
import 'package:dmt/view/oximetry_result_screen.dart';
import 'package:dmt/view/re_aob.dart';
import 'package:dmt/view/splashScreen.dart';
import 'package:flutter/material.dart';

import '../view/oximetry_result_screen.dart';

class Routes{
  Routes._();
  static const root = '/root';
  static const login = '/login';
  static const home = '/home';
  static const oximetryResultScreen = '/OximetryResultScreen';
  static const homeSleepTestingAob = '/HomeSleepTestingAob';
  static const reAobScreen = '/ReAobScreen';
  static const deviceConnect = '/deviceConnect';
  static const eSign = '/eSign';
  static const deviceSync = '/DeviceSync';
  static const esignComplete = '/EsignComplete';
  //static const privacy = '/Privacy';


  static Map<String, WidgetBuilder> routes(BuildContext context) {
    return {
      root: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      oximetryResultScreen: (context) => const OximetryResultScreen(),
      homeSleepTestingAob: (context) => const HomeSleepTestingAob(),
      reAobScreen: (context) => const ReAobScreen(),
      deviceConnect: (context) => const DeviceConnect(),
      eSign: (context) => const ESign(),
      deviceSync: (context) => const DeviceSync(),
      esignComplete: (context) => const CompleteESign(),
     // privacy: (context) => const Privacy(),
    };
  }
}