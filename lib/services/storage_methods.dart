import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(
    Uint8List file,
  ) async {

    Reference ref =
        _storage.ref().child('questionFiles').child(_auth.currentUser!.uid);

    String id = const Uuid().v1();
    ref = ref.child(id);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadUserProdile(
      Uint8List file,
      String uid
      ) async {

    Reference ref =
    _storage.ref().child('profileImage').child(uid);

    String id = const Uuid().v1();
    ref = ref.child(id);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> uploadCertificate(
      Uint8List file,
      String uid
      ) async {

    Reference ref =
    _storage.ref().child('certificate').child(uid);

    String id = const Uuid().v1();
    ref = ref.child(id);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

}


