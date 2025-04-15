abstract class HomeEvent{
  const HomeEvent();
}

class FetchDataUser extends HomeEvent{
  const FetchDataUser();
}

class FetchDataAdmin extends HomeEvent{
  const FetchDataAdmin();
}

class UpdateProgress extends HomeEvent{
  int levelIndex;
  int materialIndex;
  bool value;
  UpdateProgress({required this.levelIndex,required this.materialIndex,required this.value});
}

class MoveToRoleDetail extends HomeEvent{
  String roleId;
  MoveToRoleDetail(this.roleId);
}

class AdditionalHandleState extends HomeEvent {}