import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_path/model/news.dart';
import 'package:code_path/model/users.dart';

class NewsSource {
  static Future<List<News>> getAllNews() async {
    var ref = await FirebaseFirestore.instance.collection('News').get();
    return ref.docs.map((e) => News.fromJson(e.data())).toList();
  }

  static Future<News> getNewsDetail(String id) async{
    var ref = FirebaseFirestore.instance.collection("News").doc(id);
    var result = await ref.get();
    return News.fromJson(result.data()!);
  }

  static Future<String> getUsername(String id)async{
    var ref = FirebaseFirestore.instance.collection("Users").doc(id);
    var result = await ref.get();
    var data = Users.fromJson(result.data()!);
    return data.username!;
  }

  static Future<Map<String,dynamic>> addComment(String idNews,Map<String,dynamic> comment) async{
    Map<String, dynamic> response = {}; 
    try{
      var instance = FirebaseFirestore
        .instance
        .collection("News")
        .doc(idNews).update({"comments": FieldValue.arrayUnion([comment])});

      await instance;
      response["message"] = "Add comment success";
      response["success"] = true;
    }on FirebaseException catch(ex){
      response["message"] = ex.message;
      response["success"] = false;
    }
    return response;
  }

  static Future<void> likeComment(String idNews,Map<String,dynamic> like)async{
    var instance = FirebaseFirestore.instance.collection("News").doc(idNews)
    .update({"likes": FieldValue.arrayUnion([like])});
    await instance;
  }

  static Future<void> unlikeComment(String idNews,Map<String,dynamic> like)async{
    var instance = FirebaseFirestore.instance.collection("News").doc(idNews)
    .update({"likes": FieldValue.arrayRemove([like])});
    await instance;
  }

  static Future<List<News>> getCountNews()async{
    var ref = await FirebaseFirestore.instance.collection("News").get();
    return ref.docs.map((e)=> News.fromJson(e.data())).toList();
  }

  static Future<Map<String, dynamic>> addNews(News news) async{
      Map<String,dynamic> response = {};
      try{
        var ref = FirebaseFirestore.instance.collection("News");
        var documentRef = await ref.add(news.toJson());
        documentRef.update({"id": documentRef.id});
        response["success"] = true;
        response["message"] = "Berhasil menambahkan news";
      }on FirebaseException catch(e){
        response["success"] = false;
        response["message"] = e.message!;
      }catch(e){
        response["success"] = false;
        response["message"] = "Unknown Error";
      }
      return response;
  }

  /**
   * firestore dont support case insensitive
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
