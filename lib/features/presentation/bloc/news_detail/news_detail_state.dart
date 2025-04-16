import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/news.dart';
import 'package:code_path/features/data/model/users.dart';

class NewsDetailState{
  final DataState<News>? news;
  final bool? isLiked;
  final DataState<String>? isClicked;
  final Users? users;
  final DataState<String>? resultAddComment;

  NewsDetailState({this.isLiked,this.news,this.users,this.isClicked,this.resultAddComment});

  factory NewsDetailState.initial(){
    return NewsDetailState(
      news: null,
      isLiked: null,
      users: null,
      isClicked: null,
      resultAddComment: null
    );
  }

  NewsDetailState copyWith({
    DataState<News>? news,
    bool? isLiked,
    Users? users,
    DataState<String>? isClicked,
    DataState<String>? resultAddComment
  }){
    return NewsDetailState(
      news: news??this.news,
      isLiked: isLiked??this.isLiked,
      users: users??this.users,
      isClicked: isClicked??this.isClicked,
      resultAddComment: resultAddComment??this.resultAddComment
    );
  }
}