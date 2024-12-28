import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_path/model/roles.dart';

class RolesSource {
  
  static Future<List<Roles>> getRoles() async{
    var result = await FirebaseFirestore.instance.collection('Roles').get();
    return result.docs.map((e)=> Roles.fromJson(e.data())).toList();
  }

  static Future<Roles> getRolesDetail(String roles) async{
    var ref = FirebaseFirestore.instance.collection('Roles').doc(roles);
    var doc = await ref.get();
    return Roles.fromJson(doc.data()!);
  }
}