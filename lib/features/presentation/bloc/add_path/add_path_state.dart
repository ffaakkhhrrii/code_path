import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';

class AddPathState {
  final List<Tool>? tools;
  final List<Level>? levels;
  final DataState<String>? resultSubmitPath;

  AddPathState({this.levels,this.resultSubmitPath,this.tools});

  factory AddPathState.initial(){
    return AddPathState(
      tools: [],
      levels: [],
      resultSubmitPath: null
    );
  }

  AddPathState copyWith({
     List<Tool>? tools,
     List<Level>? levels,
     DataState<String>? resultSubmitPath
  }){
    return AddPathState(
      tools: tools??this.tools,
      levels: levels??this.levels,
      resultSubmitPath: resultSubmitPath??this.resultSubmitPath
    );
  }
}