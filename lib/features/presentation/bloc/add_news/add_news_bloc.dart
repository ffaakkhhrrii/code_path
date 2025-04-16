import 'package:bloc/bloc.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/domain/usecase/admin/admin_usecase.dart';
import 'package:code_path/features/domain/usecase/roles/roles_usecase.dart';
import 'package:code_path/features/presentation/bloc/add_news/add_news_event.dart';
import 'package:code_path/features/presentation/bloc/add_news/add_news_state.dart';

class AddNewsBloc extends Bloc<AddNewsEvent,AddNewsState>{
  final RolesUseCase rolesUseCase;
  final AdminUseCase adminUseCase;

  AddNewsBloc({required this.rolesUseCase,required this.adminUseCase}):super(AddNewsState.initial()){
    on<FetchThemeData> (onFetchThemeData);
    on<SubmitNews> (onSubmitNews);
  }

  void onFetchThemeData(FetchThemeData event,Emitter<AddNewsState>emit)async{
    var result = await rolesUseCase.getRoles();
    emit(state.copyWith(roles: result));
  }

  void onSubmitNews(SubmitNews event,Emitter<AddNewsState>emit)async{
    emit(state.copyWith(resultSubmit: const DataLoading()));
    var result = await adminUseCase.addNews(event.news);
    if(result is DataSuccess){
      print("gg mas fakhri ${result.data}");
      emit(state.copyWith(resultSubmit: DataSuccess(result.data!)));
    }else if(result is DataFailed){
      emit(state.copyWith(resultSubmit: DataFailed(result.error!)));
    }

  }
}