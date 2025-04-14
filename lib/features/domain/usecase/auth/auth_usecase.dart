import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/data/model/users.dart';
import 'package:code_path/features/data/repository/auth_repository.dart';
import 'package:code_path/features/domain/usecase/auth/auth_interactor.dart';

class AuthUseCase implements AuthInteractor{
  final AuthRepository repository;

  AuthUseCase({required this.repository});

  @override
  Future<DataState<String>> login(String email, String password) {
    return repository.login(email, password);
  }

  @override
  Future<DataState<String>> register(Users user, Roles role) {
    return repository.register(user, role);
  }

  @override
  Future<DataState<Users>> getUser() {
    return repository.getUser();
  }

}