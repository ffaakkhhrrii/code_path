import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';

abstract class SignUpState{
  final String? result;
  final Exception? error;
  final DataState<List<Roles>>? roles;
  
  const SignUpState({this.result,this.error,this.roles});
}

class SignUpIdle extends SignUpState{
  const SignUpIdle();
}

class SignUpLoading extends SignUpState{
  const SignUpLoading();
}

class SignUpSuccess extends SignUpState{
  const SignUpSuccess(String result): super(result: result);
}

class SignUpFailed extends SignUpState{
  const SignUpFailed(Exception error): super(error: error);
}

class ShowRolesState extends SignUpState{
  const ShowRolesState(DataState<List<Roles>>? roles):super(roles: roles);
}
