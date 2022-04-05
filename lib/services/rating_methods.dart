import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class RatingMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> postRating(
      {required double rating,
      required String subCategoryId,
      required String lessonId,
      required String comment}) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot user = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      Map<String, dynamic> userData = user.data() as Map<String, dynamic>;

      await _firestore
          .collection("categories")
          .doc(subCategoryId)
          .collection(subCategoryId)
          .doc(lessonId)
          .collection('ratings')
          .doc(_auth.currentUser!.uid)
          .set({
        "rating": rating,
        "comment": comment,
        "timestamp": Timestamp.fromDate(DateTime.now()),
        "userProfilePic": userData['photoUrl'],
      });

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
