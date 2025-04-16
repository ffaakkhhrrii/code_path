import 'package:bloc/bloc.dart';
import 'package:code_path/core/config/session.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/domain/usecase/news/news_usecase.dart';
import 'package:code_path/features/presentation/bloc/news_detail/news_detail_event.dart';
import 'package:code_path/features/presentation/bloc/news_detail/news_detail_state.dart';

class NewsDetailBloc extends Bloc<NewsDetailEvent,NewsDetailState>{
  final NewsUseCase newsUseCase;

  NewsDetailBloc(this.newsUseCase):super(NewsDetailState.initial()){
    on<FetchDetailNews> (onFetchDetailNews);
    on<ToggleLikeNews> (onToggleLikeNews);
    on<AddComment> (onAddComment);
  }

  void onFetchDetailNews(FetchDetailNews event,Emitter<NewsDetailState> emit)async{
    emit(state.copyWith(news: const DataLoading()));

    var getUser = await Session.getUser();
    emit(state.copyWith(users: getUser));

    var result = await newsUseCase.getNews(event.id);
    var isLiked = result.data!.likes!.any((like) => like.id == state.users!.id);
    emit(state.copyWith(news: result,isLiked: isLiked));
  }

  void onToggleLikeNews(ToggleLikeNews event, Emitter<NewsDetailState> emit)async{
    emit(state.copyWith(isClicked: const DataLoading()));
    if(state.isLiked!){
      var result = await newsUseCase.unlikeNews(event.newsId, event.like);
      if(result is DataSuccess){
        emit(state.copyWith(isLiked: false,isClicked: const DataSuccess("UnLiked Success")));
        var updateComment = await newsUseCase.getNews(event.newsId);
        emit(state.copyWith(news: updateComment));
      }else if(result is DataFailed){
        emit(state.copyWith(isClicked: DataFailed(result.error!)));
      }
    }else{
      var result = await newsUseCase.likeNews(event.newsId, event.like);
      if(result is DataSuccess){
        emit(state.copyWith(isLiked: true,isClicked: const DataSuccess("Liked Success")));
        var updateComment = await newsUseCase.getNews(event.newsId);
        emit(state.copyWith(news: updateComment));
      }else if(result is DataFailed){
        emit(state.copyWith(isClicked: DataFailed(result.error!)));
      }
    }
  }

  void onAddComment(AddComment event, Emitter<NewsDetailState> emit) async{

    emit(state.copyWith(resultAddComment: const DataLoading()));
    var result = await newsUseCase.addComment(event.newsId, event.comment);

    if(result is DataSuccess){
      emit(state.copyWith(resultAddComment: DataSuccess(result.data!)));
      var updateComment = await newsUseCase.getNews(event.newsId);
      emit(state.copyWith(news: updateComment));
    }else if(result is DataFailed){
      emit(state.copyWith(resultAddComment: DataFailed(result.error!)));
    }
  }

}