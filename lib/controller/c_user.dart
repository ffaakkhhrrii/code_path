import 'package:code_path/config/session.dart';
import 'package:code_path/model/progress_user.dart';
import 'package:code_path/model/users.dart';
import 'package:code_path/source/progress_source.dart';
import 'package:code_path/source/user_source.dart';
import 'package:get/get.dart';

class CUser extends GetxController {
  final _data = Users().obs;
  final _userProgress = ProgressUser().obs;

  ProgressUser get progressUser => _userProgress.value;
  
  getProgress(String userId,String roleid) async{
    _userProgress.value = await UserSource.getProgress(userId, roleid);
    update();
  }

  updateProgress(String userId,String roleId,int levelIndex,int materialIndex,bool value)async{
    ProgressUser progress = progressUser;

    Level level = progress.levels![levelIndex];
    Materials material = level.materials![materialIndex];
    material.isDone = value;
    List<Map<String, dynamic>> updatedMaterials = List.from(progress.levels!.map((lev) {
      return lev.toJson();
    }));
    await ProgressSource.updateProgress(userId, roleId, updatedMaterials);
  }
  
  Users get data => _data.value;
  setData(Users n)=> _data.value = n;
}