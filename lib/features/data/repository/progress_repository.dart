import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/data_source/progress_source.dart';
import 'package:code_path/features/data/data_source/user_source.dart';
import 'package:code_path/features/data/model/progress_user.dart';
import 'package:code_path/features/domain/repository/iprogress_repository.dart';

class ProgressRepository implements IProgressRepository{

  @override
  Future<DataState<ProgressUser>> getProgress(String userId, String rolesId) async {
    try{
      var result = await UserSource.getProgress(userId, rolesId);
      return DataSuccess(result);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<void>> updateProgress(String userId, String rolesId, List<Map<String, dynamic>> updateValue)async {
    try{
      var update = await ProgressSource.updateProgress(userId, rolesId, updateValue);
      return DataSuccess(update);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

}