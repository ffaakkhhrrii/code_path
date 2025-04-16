import 'dart:convert';

import 'package:code_path/features/data/model/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Future<bool> saveUser(Users user) async{
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> mapUser = user.toJson();
    String stringUser = jsonEncode(mapUser);
    bool success = await pref.setString('users', stringUser);
    return success;
  }

  static Future<Users> getUser() async{
    Users user = Users();
    final pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString('users');
    if(stringUser != null){
      Map<String, dynamic> mapUser = jsonDecode(stringUser);
      user = Users.fromJson(mapUser);
    }
    return user;
  }

  static Future<bool> clearUser() async {
    final pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('users');
    return success; 
  }
}