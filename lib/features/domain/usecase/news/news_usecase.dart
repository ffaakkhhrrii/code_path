import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/news.dart';
import 'package:code_path/features/data/repository/news_repository.dart';
import 'package:code_path/features/domain/usecase/news/news_interactor.dart';

class NewsUseCase implements NewsInteractor{
  final NewsRepository repository;

  NewsUseCase(this.repository);

  @override
  Future<DataState<List<News>>> getListNews() {
    return repository.getListNews();
  }

  @override
  Future<DataState<News>> getNews(String newsId) {
    return repository.getNews(newsId);
  }

  @override
  Future<DataState<void>> likeNews(String idNews, Map<String, dynamic> like) {
    return repository.likeNews(idNews, like);
  }

  @override
  Future<DataState<void>> unlikeNews(String idNews, Map<String, dynamic> like) {
    return repository.unlikeNews(idNews, like);
  }

  @override
  Future<DataState<String>> getUsername(String userId) {
    return repository.getUsername(userId);
  }

  @override
  Future<DataState<String>> addComment(String idNews, Map<String, dynamic> comment) {
    return repository.addComment(idNews, comment);
  }

}