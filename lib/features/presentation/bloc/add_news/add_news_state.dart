import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';

class AddNewsState{
  final DataState<List<Roles>>? roles;
  final DataState<String>? resultSubmit;

  AddNewsState({this.resultSubmit,this.roles});

  factory AddNewsState.initial(){
    return AddNewsState(
      roles: null,
      resultSubmit:null
    );
  }

  AddNewsState copyWith({
    DataState<List<Roles>>? roles,
    DataState<String>? resultSubmit
  }){
    return AddNewsState(
      roles: roles??this.roles,
      resultSubmit: resultSubmit??this.resultSubmit
    );
  }
}