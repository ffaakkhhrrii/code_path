import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/news.dart';

abstract class INewsRepository{
  Future<DataState<List<News>>> getListNews();
  Future<DataState<News>> getNews(String newsId);
  Future<DataState<void>> likeNews(String idNews,Map<String,dynamic> like);
  Future<DataState<void>> unlikeNews(String idNews,Map<String,dynamic> like);
  Future<DataState<String>> getUsername(String userId);
  Future<DataState<String>> addComment(String idNews,Map<String,dynamic> comment);
}