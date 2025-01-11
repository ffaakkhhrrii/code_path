import 'package:code_path/config/session.dart';
import 'package:code_path/model/news.dart';
import 'package:code_path/source/news_source.dart';
import 'package:get/get.dart';

class CNews extends GetxController{
  final _listNews = <News>[].obs;

  // ignore: invalid_use_of_protected_member
  List<News> get listNews => _listNews.value;

  getListNews() async{
    _listNews.value = await NewsSource.getAllNews();
    update();
  }

  searchNews(String text) async{
    List<News> list = await NewsSource.getAllNews();
    _listNews.value = text.isEmpty ? list : list.where((e)=> e.title!.isCaseInsensitiveContains(text)||e.description!.isCaseInsensitiveContains(text)).toList();
    //_listNews.value = await NewsSource.searchNews(text);
    update();
  }

  @override
  void onInit() {
    getListNews();
    super.onInit();
  }
}