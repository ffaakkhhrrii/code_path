
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/data/model/users.dart';

class PathState{
  final DataState<List<Roles>>? listRoles;
  final DataState<Users>? users;

  PathState({this.listRoles,this.users});

  factory PathState.initial(){
    return PathState(
      listRoles: null,
      users: null
    );
  }

  PathState copyWith({
    DataState<List<Roles>>? listRoles,
    DataState<Users>? users
  }){
    return PathState(
      listRoles: listRoles??this.listRoles,
      users: users??this.users
    );
  }
}

