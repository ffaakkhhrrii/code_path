import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/progress_user.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/data/model/users.dart';

class HomeState{
  final DataState<Users>? users;
  final DataState<int>? newsCount;
  final DataState<int>? usersCount;
  final DataState<ProgressUser>? progressUser;
  final DataState<Roles>? role;

  const HomeState({this.users,this.newsCount,this.progressUser,this.usersCount,this.role});

  factory HomeState.initial(){
    return const HomeState(
      users: null,
      newsCount: null,
      usersCount: null,
      progressUser: null,
      role: null
    );
  }

  HomeState copyWith({
    DataState<Users>? users,
    DataState<int>? newsCount,
    DataState<ProgressUser>? progressUser,
    DataState<int>? usersCount,
    DataState<Roles>? role
  }){
    return HomeState(
      users: users ?? this.users,
      newsCount: newsCount?? this.newsCount,
      usersCount: usersCount??this.usersCount,
      progressUser: progressUser?? this.progressUser,
      role: role??this.role
    );
  }

}