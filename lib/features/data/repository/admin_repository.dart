import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/data_source/news_source.dart';
import 'package:code_path/features/data/data_source/user_source.dart';
import 'package:code_path/features/domain/repository/iadmin_repository.dart';

class AdminRepository implements IAdminRepository{

  @override
  Future<DataState<int>> getUsersCount() async{
    try{
      var result = await UserSource.getAllUser();
      return DataSuccess(result.length);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<int>> getNewsCount() async {
    try{
      var result = await NewsSource.getAllNews();
      return DataSuccess(result.length);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

}