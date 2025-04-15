import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/progress_user.dart';
import 'package:code_path/features/data/repository/progress_repository.dart';
import 'package:code_path/features/domain/usecase/progress/progress_interactor.dart';

class ProgressUseCase implements ProgressInteractor{

  final ProgressRepository repository;

  ProgressUseCase(this.repository);

  @override
  Future<DataState<ProgressUser>> getProgress(String userId, String rolesId) {
    return repository.getProgress(userId, rolesId);
  }

  @override
  Future<DataState<void>> updateProgress(String userId, String rolesId, List<Map<String, dynamic>> updateValue) {

    return repository.updateProgress(userId, rolesId, updateValue);
  }

}