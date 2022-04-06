import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CertificateMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createCertificate({
    required List data,
  }) async {
    String res = "Some error Occurred";
    try {
      List courseIds = [];
      num marks = 0;
      final ids = data.map((e) => e.id).toSet();
      data.retainWhere((x) => ids.remove(x.id));
      log(data.toString());
      for (var item in data) {
        if (item.selected == true) {
          courseIds.add(item.id);
          marks = marks + item.marks;
        }
      }

      num finalMark = (marks / 500) * 100;

      await _firestore
          .collection("certificates")
          .doc(_auth.currentUser!.uid)
          .set({"marks": finalMark, "courseIds": courseIds});

      res = finalMark.toString();
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> addCertificateImages({
    required String url,
  }) async {
    String res = "Some error Occurred";
    try {
      String certificateId = const Uuid().v1();
      await _firestore
          .collection("certificates")
          .doc(_auth.currentUser!.uid)
          .collection("my_certificates")
          .doc(certificateId)
          .set({"url": url});

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> deleteCertificate(String certificateId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('certificates').doc(_auth.currentUser!.uid).collection("my_certificates").doc(certificateId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


}
