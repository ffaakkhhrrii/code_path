import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';

class SignUpState{
  final DataState<String>? result;
  final DataState<List<Roles>>? roles;
  
  const SignUpState({this.result,this.roles});

  factory SignUpState.initial() {
    return const SignUpState(
      result: null,
      roles: null,
    );
  }

  SignUpState copyWith({
    DataState<String>? result,
    Exception? error,
    DataState<List<Roles>>? roles,
  }) {
    return SignUpState(
      result: result ?? this.result,
      roles: roles ?? this.roles,
    );
  }

}