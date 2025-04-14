
abstract class LoginState{
  final String? result;
  final Exception? error;

  const LoginState({this.result,this.error});
}

class LoginIdle extends LoginState{
  const LoginIdle();
}

class LoginLoading extends LoginState{
  const LoginLoading();
}

class LoginSuccess extends LoginState{
  const LoginSuccess(String result): super(result: result);
}

class LoginFailed extends LoginState{
  const LoginFailed(Exception error): super(error: error);
}