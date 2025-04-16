import 'package:code_path/features/data/model/roles.dart';

abstract class AddPathEvent{
  const AddPathEvent();
}

class SubmitPath extends AddPathEvent{
  Roles roles;
  SubmitPath(this.roles);
}

class UpdateTools extends AddPathEvent{
  String name;
  String image;
  UpdateTools({required this.name,required this.image});
}

class UpdateLevels extends AddPathEvent{
  String name;
  String description;
  UpdateLevels({required this.name,required this.description});
}

class DeleteTools extends AddPathEvent{
  int index;
  DeleteTools(this.index);
}

class UpdateMaterials extends AddPathEvent{
  String name;
  String recommendation;
  int index;
  UpdateMaterials({required this.name,required this.recommendation,required this.index});
}

class DeleteMaterials extends AddPathEvent{
  int materialIndex;
  int levelIndex;
  DeleteMaterials({required this.materialIndex,required this.levelIndex});
}