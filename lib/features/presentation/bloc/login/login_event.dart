abstract class LoginEvent{
  const LoginEvent();
}

class Login extends LoginEvent{
  String email;
  String password;
  Login({required this.email,required this.password});
}