import 'package:shared_preferences/shared_preferences.dart';
class SessionManager{
  SharedPreferences prefs;

  SessionManager(this.prefs);

  void setStringData(String key,String value){
    prefs.setString(key, value);
    prefs.commit();
  }

  String? getStringData(String key){
    return prefs.containsKey(key) ? prefs.getString(key) : "";
  }

  void clearSession(){
    prefs.clear();
    prefs.commit();
  }

}