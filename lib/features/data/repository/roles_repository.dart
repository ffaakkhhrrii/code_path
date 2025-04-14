import 'package:code_path/core/resource/data_state.dart';
import 'package:code_path/features/data/data_source/roles_source.dart';
import 'package:code_path/features/data/model/roles.dart';
import 'package:code_path/features/domain/repository/iroles_repository.dart';

class RolesRepository implements IRolesRepository{

  @override
  Future<DataState<List<Roles>>> getRoles() async{
    try{
      var result = await RolesSource.getRoles();
      return DataSuccess(result);
    }on Exception catch(e){
      return DataFailed(e);
    }
  }

}