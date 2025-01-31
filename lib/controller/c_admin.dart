import 'package:code_path/model/news.dart';
import 'package:code_path/model/users.dart';
import 'package:code_path/source/news_source.dart';
import 'package:code_path/source/user_source.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CAdmin extends GetxController {
  final _listUsers = <Users>[].obs;
  final _listNews = <News>[].obs;

  List<News> get listNews => _listNews.value;
  List<Users> get listUsers => _listUsers.value;

  getNewsCount() async{
    _listNews.value = await NewsSource.getCountNews();
    update();
  }

  getUsersCount()async{
    _listUsers.value = await UserSource.getAllUser();
    update();
  }

  @override
  void onInit() {
    getNewsCount();
    getUsersCount();
    super.onInit();
  }
}