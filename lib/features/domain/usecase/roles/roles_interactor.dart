import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/model/roles.dart';

abstract class RolesInteractor{
  Future<DataState<List<Roles>>> getRoles();
}