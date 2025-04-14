import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/data/repository/roles_repository.dart';
import 'package:code_path/features/domain/usecase/roles/roles_interactor.dart';

class RolesUseCase implements RolesInteractor{

  final RolesRepository repository;

  RolesUseCase(this.repository);

  @override
  Future<DataState<List<Roles>>> getRoles() {
    return repository.getRoles();
  }

}