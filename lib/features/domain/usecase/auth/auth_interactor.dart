import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/data/model/users.dart';

abstract class AuthInteractor{
  Future<DataState<String>> login(String email,String password);
  Future<DataState<String>> register(Users user, Roles role);
  Future<DataState<Users>> getUser();
}