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

}