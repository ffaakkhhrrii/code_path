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

}