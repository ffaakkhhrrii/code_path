import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/repository/admin_repository.dart';
import 'package:code_path/features/domain/usecase/admin/admin_interactor.dart';

class AdminUseCase implements AdminInteractor{
  final AdminRepository repository;

  AdminUseCase(this.repository);

  @override
  Future<DataState<int>> getUsersCount() {
    return repository.getUsersCount();
  }

  @override
  Future<DataState<int>> getNewsCount() {
    return repository.getNewsCount();
  }

}