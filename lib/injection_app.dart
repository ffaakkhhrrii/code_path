import 'package:code_path/features/data/repository/admin_repository.dart';
import 'package:code_path/features/data/repository/auth_repository.dart';
import 'package:code_path/features/data/repository/progress_repository.dart';
import 'package:code_path/features/data/repository/roles_repository.dart';
import 'package:code_path/features/domain/usecase/admin/admin_usecase.dart';
import 'package:code_path/features/domain/usecase/auth/auth_usecase.dart';
import 'package:code_path/features/domain/usecase/progress/progress_usecase.dart';
import 'package:code_path/features/domain/usecase/roles/roles_usecase.dart';
import 'package:code_path/features/presentation/bloc/home/home_bloc.dart';
import 'package:code_path/features/presentation/bloc/login/login_bloc.dart';
import 'package:code_path/features/presentation/bloc/path/path_bloc.dart';
import 'package:code_path/features/presentation/bloc/signup/signup_bloc.dart';
import 'package:get_it/get_it.dart';

final s1 = GetIt.instance;

Future<void> initializeDependencies() async{

  s1.registerSingleton<AuthRepository>(AuthRepository());

  s1.registerSingleton<RolesRepository>(RolesRepository());

  s1.registerSingleton<ProgressRepository>(ProgressRepository());

  s1.registerSingleton<AdminRepository>(AdminRepository());

  s1.registerSingleton<AuthUseCase>(AuthUseCase(repository: s1()));

  s1.registerSingleton<RolesUseCase>(RolesUseCase(s1()));

  s1.registerSingleton<ProgressUseCase>(ProgressUseCase(s1()));

  s1.registerSingleton<AdminUseCase>(AdminUseCase(s1()));

  s1.registerFactory<LoginBloc>(()=>LoginBloc(s1()));

  s1.registerFactory<SignUpBloc>(()=>SignUpBloc(
    rolesUseCase: s1(),
    useCase: s1()
  ));

  s1.registerFactory<HomeBloc>(()=>HomeBloc(
    authUseCase: s1(),
    progressUseCase: s1(),
    adminUseCase: s1(),
    rolesUseCase: s1()
  ));

  s1.registerFactory<PathBloc>(()=>PathBloc(
      s1()
  ));
}