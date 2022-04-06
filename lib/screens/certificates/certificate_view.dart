import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/screens/certificates/certificate_listing.dart';
import 'package:git_explorer/services/certificate_methods.dart';
import 'package:git_explorer/services/storage_methods.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

class CertificateView extends StatefulWidget {
  final String marks;
  const CertificateView({Key? key, required this.marks}) : super(key: key);

  @override
  State<CertificateView> createState() => _CertificateViewState();
}

class _CertificateViewState extends State<CertificateView> {
  int _counter = 0;
  late Uint8List _imageFile;
  late String username;
  bool loading = false;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  void getUserName() async {
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    Map<String, dynamic> data = user.data() as Map<String, dynamic>;

    setState(() {
      username = data["username"];
    });
  }

  Future<bool> capture() async {
    var res = screenshotController.capture().then((res) async {
      //Capture Done
      log(res.toString());
      setState(() {
        _imageFile = res!;
      });

      String url = await StorageMethods().uploadCertificate(
          _imageFile, FirebaseAuth.instance.currentUser!.uid);

      await CertificateMethods().addCertificateImages(url: url);

      return true;
    }).catchError((onError) {
      print(onError);
      return false;
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff251F34),
      appBar: AppBar(
        title: const Text('Certificate Viewer'),
        backgroundColor: const Color(0xff251F34),
      ),
      body: Container(
        child: Column(
          children: [
            Screenshot(
                controller: screenshotController,
                child: Container(
                  margin: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 25),
                          child: const Text(
                            "Certificate",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 25),
                          child: const Text(
                            "Git Explorer",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )),
                      Container(
                          margin: EdgeInsets.only(top: 35),
                          child: Column(
                            children: [
                              const Text(
                                "The certificate is presented to",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Text(
                                  username,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Score",
                                style: TextStyle(fontSize: 30),
                              ),
                              Text(
                                widget.marks,
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 200),
                                child: Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now()),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Container(child: Text("Issued date"))
                            ],
                          )),
                    ],
                  ),
                  color: Colors.blueGrey,
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                )),
            InkWell(
              onTap: () async {
                setState(() {
                  loading = true;
                });
                bool res = await capture();

                setState(() {
                  loading = false;
                });
                if (res) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CertificateListing()));
                }
              },
              child: Container(
                margin: const EdgeInsets.only(left: 7, right: 7, top: 15),
                child: !loading
                    ? const Text(
                        'Save Certificate',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    : const CircularProgressIndicator(color: Colors.white),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: Color(0xff14DAE2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
