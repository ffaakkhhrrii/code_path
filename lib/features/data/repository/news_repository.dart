import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/data_source/news_source.dart';
import 'package:code_path/features/data/model/news.dart';
import 'package:code_path/features/domain/repository/inews_repository.dart';

class NewsRepository implements INewsRepository{

  @override
  Future<DataState<List<News>>> getListNews()async {
    try{
      var result = await NewsSource.getAllNews();
      return DataSuccess(result);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<News>> getNews(String newsId) async{
    try{
      var result = await NewsSource.getNewsDetail(newsId);
      return DataSuccess(result);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> likeNews(String idNews, Map<String, dynamic> like) async{
    try{
      var result = await NewsSource.likeNews(idNews,like);
      return DataSuccess(result);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> unlikeNews(String idNews, Map<String, dynamic> like)async {
    try{
      var result = await NewsSource.unlikeNews(idNews,like);
      return DataSuccess(result);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<String>> getUsername(String userId) async{
    try{
      var result = await NewsSource.getUsername(userId);
      return DataSuccess(result);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<String>> addComment(String idNews, Map<String, dynamic> comment) async{
    try{
      var result = await NewsSource.addComment(idNews,comment);
      if(result['success']){
        return DataSuccess(result["message"]);
      }else{
        return DataFailed(result["message"]);
      }
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

}