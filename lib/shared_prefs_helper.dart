import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static Future<String> getIp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('ip_addr') ?? '';
  }

  static Future<bool> setIp(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('ip_addr', value);
  }
}
