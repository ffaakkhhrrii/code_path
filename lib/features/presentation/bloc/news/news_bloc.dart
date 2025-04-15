import 'package:bloc/bloc.dart';
import 'package:code_path/core/config/session.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/domain/usecase/news/news_usecase.dart';
import 'package:code_path/features/presentation/bloc/news/news_event.dart';
import 'package:code_path/features/presentation/bloc/news/news_state.dart';
import 'package:get/get.dart';

class NewsBloc extends Bloc<NewsEvent,NewsState>{
  final NewsUseCase newsUseCase;

  NewsBloc(this.newsUseCase):super(NewsState.initial()){
    on<FetchNewsData> (onFetchNewsData);
    on<SearchNews> (onSearchNews);
  }

  void onFetchNewsData(FetchNewsData event,Emitter<NewsState> emit) async{
    emit(state.copyWith(newsList: const DataLoading()));
    var result = await newsUseCase.getListNews();
    emit(state.copyWith(newsList: result));

    var resultUsers = await Session.getUser();
    emit(state.copyWith(users: DataSuccess(resultUsers)));
  }

  void onSearchNews(SearchNews event,Emitter<NewsState> emit){
    if (state.newsList?.data == null) {
      emit(state.copyWith(newsList: DataFailed(Exception("Data is empty"))));
      return;
    }

    var list = state.newsList?.data!;
    var updatedList = event.searchText.isEmpty
        ? list
        : list!.where((e) =>
    e.title!.isCaseInsensitiveContains(event.searchText) ||
        e.description!.isCaseInsensitiveContains(event.searchText)).toList();

    emit(state.copyWith(newsList: const DataLoading()));

    emit(state.copyWith(newsList: DataSuccess(updatedList!)));
  }
}