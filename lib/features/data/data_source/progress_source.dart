import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_path/features/data/model/progress_user.dart';

class ProgressSource {
  static Future<void> updateProgress(String userId, String rolesId,
      List<Map<String, dynamic>> updateValue) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Progress')
        .doc(rolesId)
        .update({'levels': updateValue});
  }
}