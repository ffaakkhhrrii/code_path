import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_path/config/session.dart';
import 'package:code_path/model/progress_user.dart';
import 'package:code_path/model/roles.dart';
import 'package:code_path/model/users.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:get/get.dart';

class UserSource {
  static Future<Map<String, dynamic>> signIn(
      String email, String password) async {
    Map<String, dynamic> response = {};
    try {
      final credential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      response['success'] = true;
      response['message'] = 'Sign in success';
      String uid = credential.user!.uid;
      Users user = await getWhereId(uid);
      Session.saveUser(user);
    } on auth.FirebaseAuthException catch (e) {
      response['success'] = false;
      response['message'] = 'Email/Password Salah';
    }
    return response;
  }

  static Future<Users> getWhereId(String id) async {
    DocumentReference<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection('Users').doc(id);
    DocumentSnapshot<Map<String, dynamic>> doc = await ref.get();
    return Users.fromJson(doc.data()!);
  }

  static Future<Map<String, dynamic>> signUp(Users user, Roles roles) async {
    Map<String, dynamic> response = {};
    try {
      final credential = await auth.FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!);
      String uid = credential.user!.uid;

      user.id = uid;
      var ref = FirebaseFirestore.instance.collection('Users').doc(uid);
      await ref.set(user.toJson());

      var refP = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Progress');
      var addRoles = roles.toJson();
      await refP.doc(roles.id).set(addRoles);

      response['success'] = true;
      response['message'] = 'Signup success';
    } on auth.FirebaseAuthException catch (e) {
      response['success'] = false;

      if (e.code == "email-already-in-use") {
        response['message'] = 'Email telah digunakan';
      }else if(e.code == "weak-password"){
        response['message'] = 'Password minimal 6 karakter';
      } else {
        response['message'] = 'Signup failed: ${e.message}';
      }
    } 
    return response;
  }

  static Future<ProgressUser> getProgress(String userId,String rolesId) async{
    var res = await FirebaseFirestore.instance.collection('Users').doc(userId).collection('Progress').doc(rolesId).get();
    return ProgressUser.fromJson(res.data()??{});
  }

  static Future<List<Users>> getAllUser() async{
    var res = await FirebaseFirestore.instance.collection("Users").get();
    return res.docs.map((e)=> Users.fromJson(e.data())).toList();
  }

}
