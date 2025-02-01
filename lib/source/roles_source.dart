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

  static Future<Map<String, dynamic>> addPath(Roles roles) async{
      Map<String,dynamic> response = {};
      try{
        var ref = FirebaseFirestore.instance.collection("Roles").doc(roles.id);
        await ref.set(roles.toJson());
        response["success"] = true;
        response["message"] = "Berhasil menambahkan Roles";
      }on FirebaseException catch(e){
        response["success"] = false;
        response["message"] = e.message!;
      }catch(e){
        response["success"] = false;
        response["message"] = "Unknown Error";
      }
      return response;
  }
}