import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ForumMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> postQuestion({
    required String question,
    required String imageUrl,
  }) async {
    String res = "Some error Occurred";
    try {
      DocumentSnapshot user = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      Map<String, dynamic> data = user.data() as Map<String, dynamic>;

      String questionId = const Uuid().v1();

      await _firestore.collection("questions").doc(questionId).set({
        "question": question,
        "image": imageUrl,
        "timestamp": Timestamp.fromDate(DateTime.now()),
        "username": data['username'],
        "userProfilePic": data['photoUrl'],
        "uid": data['uid'],
        "questionId": questionId,
      });

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> deleteQuestion(String questionId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('questions').doc(questionId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> editQuestion(
      {required String newQuestion,
      required String newImage,
      required String questionId}) async {
    String res = "Some error occurred";
    try {
      if (newImage != '') {
        _firestore
            .collection('questions')
            .doc(questionId)
            .update({'question': newQuestion, 'image': newImage});
      } else {
        _firestore
            .collection('questions')
            .doc(questionId)
            .update({'question': newQuestion});
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postSolution(
    String questionId,
    String solution,
  ) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot user = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      Map<String, dynamic> data = user.data() as Map<String, dynamic>;

      String solutionId = const Uuid().v1();
      _firestore
          .collection('questions')
          .doc(questionId)
          .collection('solutions')
          .doc(solutionId)
          .set({
        'userProfilePic': data['photoUrl'],
        "name": data['username'],
        "uid": data['uid'],
        'text': solution,
        'solutionId': solutionId,
        'datePublished': DateTime.now(),
        "votes": 0
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> voteSolution({
    required int votes,
    required String solutionId,
    required String questionId,
    required String type,
  }) async {
    String res = "Some error occurred";
    try {
      if (type == "upvote") {
        await _firestore
            .collection('questions')
            .doc(questionId)
            .collection('solutions')
            .doc(solutionId)
            .update({'votes': votes + 1});

        _firestore
            .collection('questions')
            .doc(questionId)
            .collection('solutions')
            .doc(solutionId)
            .collection("votedpeople")
            .doc(_auth.currentUser!.uid)
            .set({"type": "upvote"});
      } else {
        await _firestore
            .collection('questions')
            .doc(questionId)
            .collection('solutions')
            .doc(solutionId)
            .update({'votes': votes - 1});

        _firestore
            .collection('questions')
            .doc(questionId)
            .collection('solutions')
            .doc(solutionId)
            .collection("votedpeople")
            .doc(_auth.currentUser!.uid)
            .set({"type": "downvote"});
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<DocumentSnapshot> getVoted({
    required String solutionId,
    required String questionId,
  }) async {
    DocumentSnapshot response = await _firestore
        .collection('questions')
        .doc(questionId)
        .collection('solutions')
        .doc(solutionId)
        .collection("votedpeople")
        .doc(_auth.currentUser!.uid)
        .get();

    print(response);

    return response;
  }

  Future<String> deleteSolution(String solutionId, String questionId) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('questions')
          .doc(questionId)
          .collection("solutions")
          .doc(solutionId)
          .delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
