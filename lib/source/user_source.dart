import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_path/config/session.dart';
import 'package:code_path/model/users.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserSource {
  static Future<Map<String, dynamic>> signIn(
      String email, 
      String password
  ) async {
    Map<String,dynamic> response = {};
    try{
      final credential = await auth.FirebaseAuth.instance
      .signInWithEmailAndPassword(email: email, password: password);
      response['success'] = true;
      response['message'] = 'Sign in success';
      String uid = credential.user!.uid;
      Users user = await getWhereId(uid);
      Session.saveUser(user);
    } on auth.FirebaseAuthException catch(e){
      response['success'] = false;
      if(e.code == 'invalid-email'){
        response['message'] = 'No user found for that email';
      }else if(e.code == 'wrong-password'){
        response['message'] = 'Wrong password provided for that user';
      }else{
        response['message'] = 'Login Gagal';
      }
    }
    return response;
  }

  static Future<Users> getWhereId(String id) async{
    DocumentReference<Map<String,dynamic>> ref = FirebaseFirestore.instance.collection('Users').doc(id);
    DocumentSnapshot<Map<String,dynamic>> doc = await ref.get();
    return Users.fromJson(doc.data()!);
  }
}