import 'package:code_path/features/data/model/news.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/data/model/users.dart';
import 'package:code_path/features/data/data_source/news_source.dart';
import 'package:code_path/features/data/data_source/roles_source.dart';
import 'package:code_path/features/data/data_source/user_source.dart';
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

  Future<Map<String,dynamic>> addNews(News news) async{
    return NewsSource.addNews(news);
  }

  Future<Map<String,dynamic>> addPath(Roles role)async{
    return RolesSource.addPath(role);
  }

  @override
  void onInit() {
    getNewsCount();
    getUsersCount();
    super.onInit();
  }
}