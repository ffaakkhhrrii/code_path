import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/news.dart';
import 'package:code_path/features/data/model/users.dart';

class NewsState{
  final DataState<List<News>>? newsList;
  final DataState<Users>? users;

  NewsState({this.users,this.newsList});

  factory NewsState.initial(){
    return NewsState(
      newsList: null,
      users: null
    );
  }


  NewsState copyWith({
    DataState<List<News>>? newsList,
    DataState<Users>? users,
  }){
    return NewsState(
      newsList: newsList??this.newsList,
      users: users??this.users
    );
  }
}