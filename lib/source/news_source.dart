import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_path/model/news.dart';

class NewsSource {
  static Future<List<News>> getAllNews() async {
    var ref = await FirebaseFirestore.instance.collection('News').get();
    return ref.docs.map((e) => News.fromJson(e.data())).toList();
  }

  /**
   * firestore dont support cas insensitive
   * static Future<List<News>> searchNews(String text) async {
    var ref = await FirebaseFirestore.instance
        .collection('News')
        .orderBy('title')
        .orderBy('description')
        .startAt([text])
        .endAt(['$text\uf8ff'])
        .get();
    return ref.docs.map((e) => News.fromJson(e.data())).toList();
  }**/
}
