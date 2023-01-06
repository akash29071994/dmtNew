import 'package:dmt/utils/const_img_path.dart';
import 'package:dmt/utils/routes.dart';
import 'package:dmt/utils/sessionMenager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopAppBar extends StatefulWidget {
  const TopAppBar({Key? key}) : super(key: key);

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  late SharedPreferences sharedPreferences;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    sharedPreferences = await SharedPreferences.getInstance();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: SizedBox(
                height: 70,
                width: 70,
                child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: Container(
                      child: Image.asset(ConstImagesPath.back)),
                ),
              ),
            ),
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
    );
  }
}
