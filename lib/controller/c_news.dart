import 'package:code_path/config/session.dart';
import 'package:code_path/model/news.dart';
import 'package:code_path/source/news_source.dart';
import 'package:get/get.dart';

class CNews extends GetxController{
  final _listNews = <News>[].obs;
  final _news = News().obs;

  // ignore: invalid_use_of_protected_member
  List<News> get listNews => _listNews.value;

  News get news => _news.value;

  getListNews() async{
    _listNews.value = await NewsSource.getAllNews();
    update();
  }

  getNewsDetail(String id)async{
    _news.value = await NewsSource.getNewsDetail(id);
    update();
  }

  Future<Map<String, dynamic>> addComment(String idNews,Map<String,dynamic> comment) async{
    var action = await NewsSource.addComment(idNews, comment);

    if(action["success"] == true){
      await getNewsDetail(idNews);
      update();
    }

    return action;
  }

  likeComment(String idNews, Map<String,dynamic> like)async{
    await NewsSource.likeComment(idNews, like);
  }

  unlikeComment(String idNews,Map<String,dynamic> like)async{
    await NewsSource.unlikeComment(idNews, like);
  }

  searchNews(String text) async{
    List<News> list = await NewsSource.getAllNews();
    _listNews.value = text.isEmpty ? list : list.where((e)=> e.title!.isCaseInsensitiveContains(text)||e.description!.isCaseInsensitiveContains(text)).toList();
    //_listNews.value = await NewsSource.searchNews(text);
    update();
  }

  final _usernames = <String, String>{}.obs;

  Future<void> loadUsername(String userId) async {
    try {
      final username = await NewsSource.getUsername(userId);
      _usernames[userId] = username;
    } catch (e) {
      _usernames[userId] = "Unknown User";
    }
  }

  String? getUsername(String userId) => _usernames[userId];

  @override
  void onInit() {
    getListNews();
    super.onInit();
  }
}