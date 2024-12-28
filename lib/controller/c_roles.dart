import 'package:code_path/model/roles.dart';
import 'package:code_path/model/users.dart';
import 'package:code_path/source/roles_source.dart';
import 'package:get/get.dart';

class CRoles extends GetxController {
  final _listRoles = <Roles>[].obs;
  final _dataRole = Roles().obs;

  // ignore: invalid_use_of_protected_member
  List<Roles> get listRoles => _listRoles.value;

  getListRoles()async{
    _listRoles.value = await RolesSource.getRoles();
    update();
  }
  
  Roles get dataRole => _dataRole.value;

  getDataRole(String role)async{
    _dataRole.value = await RolesSource.getRolesDetail(role);
    update();
  }

  @override
  void onInit() {
    getListRoles();
    super.onInit();
  }
}