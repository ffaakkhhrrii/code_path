import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/data/model/users.dart';

abstract class SignUpEvent{
  const SignUpEvent();
}

class SignUp extends SignUpEvent{
  Users users;
  Roles roles;
  SignUp({required this.users,required this.roles});
}

class ShowRole extends SignUpEvent{
  const ShowRole();
}