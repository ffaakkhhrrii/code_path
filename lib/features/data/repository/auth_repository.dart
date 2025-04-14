import 'package:code_path/core/config/session.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/data_source/user_source.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/data/model/users.dart';
import 'package:code_path/features/domain/repository/iauth_repository.dart';

class AuthRepository implements IAuthRepository{
  @override
  Future<DataState<String>> login(String email, String password) async {
    try{
      var result = await UserSource.signIn(email,password);
      if(result['success'] == true){
        return DataSuccess(result['message']);
      }else{
        return DataFailed(Exception(result['message']));
      }
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<String>> register(Users user, Roles role) async {
    try{
      var result = await UserSource.signUp(user,role);
      if(result['success'] == true){
        return DataSuccess(result['message']);
      }else{
        return DataFailed(Exception(result['message']));
      }
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

  @override
  Future<DataState<Users>> getUser() async {
    try{
      var user = await Session.getUser();
      return DataSuccess(user);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }


}