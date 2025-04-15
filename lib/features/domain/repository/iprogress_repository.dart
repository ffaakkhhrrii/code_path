import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/progress_user.dart';

abstract class IProgressRepository{
  Future<DataState<ProgressUser>> getProgress(String userId,String rolesId);
  Future<DataState<void>> updateProgress(String userId, String rolesId, List<Map<String, dynamic>> updateValue);
}