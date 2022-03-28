import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class RatingMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> postRating(
      {required double rating, required String questionId}) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot user = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;

      String ratingId = const Uuid().v1();

      await _firestore.collection("rating").doc(ratingId).set({
        "rating": rating,
        "username": data['username'],
        "timestamp": Timestamp.fromDate(DateTime.now()),
        "questionId": questionId,
      });

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> editQuestion(
      {required String ratingId, required double rating}) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('rating')
          .doc(ratingId)
          .update({'question': rating});

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteQuestion(String ratingId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('rating').doc(ratingId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
