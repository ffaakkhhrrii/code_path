import 'package:bloc/bloc.dart';
import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/domain/usecase/admin/admin_usecase.dart';
import 'package:code_path/features/presentation/bloc/add_path/add_path_event.dart';
import 'package:code_path/features/presentation/bloc/add_path/add_path_state.dart';

class AddPathBloc extends Bloc<AddPathEvent,AddPathState>{
  final AdminUseCase adminUseCase;

  AddPathBloc(this.adminUseCase):super(AddPathState.initial()){
    on<SubmitPath> (onSubmitPath);
    on<UpdateLevels> (onUpdateLevels);
    on<UpdateTools> (onUpdateTools);
    on<DeleteTools> (onDeleteTools);
    on<DeleteMaterials> (onDeleteMaterials);
    on<UpdateMaterials> (onUpdateMaterials);
  }

  void onSubmitPath(SubmitPath event,Emitter<AddPathState> emit) async{
    emit(state.copyWith(resultSubmitPath: const DataLoading()));
    var result = await adminUseCase.addRoles(event.roles);
    emit(state.copyWith(resultSubmitPath: result));
  }

  void onUpdateMaterials(UpdateMaterials event,Emitter<AddPathState> emit){
    final updatedLevels = List<Level>.from(state.levels ?? []);

    final Level currentLevel = updatedLevels[event.index];

    final updatedMaterials = List<Materials>.from(currentLevel.materials ?? []);

    updatedMaterials.add(
      Materials(
        name: event.name,
        recommendation: event.recommendation,
      ),
    );

    final updatedLevel = currentLevel.copyWith(materials: updatedMaterials);

    updatedLevels[event.index] = updatedLevel;

    emit(state.copyWith(levels: updatedLevels));

  }

  void onDeleteTools(DeleteTools event, Emitter<AddPathState> emit){
    final updatedTools = List<Tool>.from(state.tools ?? []);
    updatedTools.removeAt(event.index);
    emit(state.copyWith(tools: updatedTools));
  }

  void onDeleteMaterials(DeleteMaterials event, Emitter<AddPathState> emit){
    final updatedLevels = List<Level>.from(state.levels ?? []);

    final Level currentLevel = updatedLevels[event.levelIndex];

    final updatedMaterials = List<Materials>.from(currentLevel.materials ?? []);

    updatedMaterials.removeAt(event.materialIndex);

    final updatedLevel = currentLevel.copyWith(materials: updatedMaterials);

    updatedLevels[event.levelIndex] = updatedLevel;

    emit(state.copyWith(levels: updatedLevels));
  }

  void onUpdateLevels(UpdateLevels event,Emitter<AddPathState> emit){
    final updatedLevels = List<Level>.from(state.levels ?? []);
    updatedLevels.add(Level(
      name: event.name,
      description: event.description,
      materials: [],
    ));
    emit(state.copyWith(levels: updatedLevels));
  }

  void onUpdateTools(UpdateTools event,Emitter<AddPathState> emit){
    final updatedTools = List<Tool>.from(state.tools ?? []);
    updatedTools.add(Tool(name: event.name, image: event.image));
    emit(state.copyWith(tools: updatedTools));
  }
}