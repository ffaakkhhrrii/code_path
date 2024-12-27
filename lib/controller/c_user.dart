import 'package:code_path/model/users.dart';
import 'package:get/get.dart';

class CUser extends GetxController {
  final _data = Users().obs;
  
  Users get data => _data.value;
  setData(Users n)=> _data.value = n;
}