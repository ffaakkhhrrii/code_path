import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/news.dart';

abstract class NewsInteractor{
  Future<DataState<List<News>>> getListNews();
}