import 'package:bloc/bloc.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/domain/usecase/auth/auth_usecase.dart';
import 'package:code_path/features/presentation/bloc/login/login_event.dart';
import 'package:code_path/features/presentation/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  final AuthUseCase useCase;

  LoginBloc(this.useCase):super(const LoginIdle()){
    on<Login>(onLogin);
  }

  void onLogin(Login event,Emitter<LoginState> emit) async {
    emit(const LoginLoading());
    final result = await useCase.login(event.email, event.password);
    if(result is DataSuccess){
      emit(LoginSuccess(result.data??"Login Success"));
    }

    if(result is DataFailed){
      emit(LoginFailed(result.error!));
    }
  }
}