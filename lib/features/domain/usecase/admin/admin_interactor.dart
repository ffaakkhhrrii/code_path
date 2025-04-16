import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/news.dart';

abstract class AdminInteractor{
  Future<DataState<int>> getUsersCount();
  Future<DataState<int>> getNewsCount();
  Future<DataState<String>> addNews(News news);

}