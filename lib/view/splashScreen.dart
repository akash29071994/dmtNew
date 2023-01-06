import 'package:dmt/api/api.dart';
import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/const_lables.dart';
import 'package:dmt/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? isLogin = sharedPreferences.getString(ConstLables.isLogin);

    if(isLogin != null){
      print("isLogin= $isLogin");
    }

    Future.delayed(const Duration(seconds: 4),
            () {
          if(isLogin == "true"){
            Navigator.of(context)
                .pushReplacementNamed(Routes.home);
          }else{
            Navigator.of(context)
                .pushReplacementNamed(Routes.login);
          }

        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ConstImagesPath.bg),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Image.asset(ConstImagesPath.dmt_logo),
          )),
    );
  }
}
