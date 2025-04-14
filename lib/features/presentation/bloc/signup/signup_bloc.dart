import 'package:bloc/bloc.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/domain/usecase/auth/auth_usecase.dart';
import 'package:code_path/features/domain/usecase/roles/roles_usecase.dart';
import 'package:code_path/features/presentation/bloc/signup/signup_event.dart';
import 'package:code_path/features/presentation/bloc/signup/signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent,SignUpState>{
  final AuthUseCase useCase;
  final RolesUseCase rolesUseCase;

  SignUpBloc({required this.useCase, required this.rolesUseCase}):super(const SignUpIdle()){
    on<SignUp> (onSignUp);
    on<ShowRole> (onShowRole);
  }

  void onSignUp(SignUp event,Emitter<SignUpState> emit) async{
    emit(const SignUpLoading());
    final result = await useCase.register(event.users,event.roles);

    if(result is DataSuccess){
      emit(SignUpSuccess(result.data!));
    }

    if(result is DataFailed){
      emit(SignUpFailed(result.error!));
    }
  }

  void onShowRole(ShowRole event, Emitter<SignUpState> emit) async{
    final result = await rolesUseCase.getRoles();
    emit(ShowRolesState(result));
  }
}