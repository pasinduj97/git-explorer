import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/services/certificate_methods.dart';

class CertificateListing extends StatefulWidget {
  const CertificateListing({Key? key}) : super(key: key);

  @override
  State<CertificateListing> createState() => _CertificateListingState();
}

class _CertificateListingState extends State<CertificateListing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff251F34),
      appBar: AppBar(
        title: Text("My certificates"),
        backgroundColor: const Color(0xff251F34),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('certificates')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection("my_certificates")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot != null) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onDoubleTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Delete Certificate'),
                          content: const Text(
                              'Certificate will be permanently deleted'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context, 'Cancel');
                                await CertificateMethods().deleteCertificate(
                                    snapshot.data!.docs[index].reference.id);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ),
                      child: Container(
                          margin: const EdgeInsets.all(5.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.80,
                            width: MediaQuery.of(context).size.width * 0.80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                snapshot.data!.docs[index].get("url"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                    );
                  });
            } else {
              return const Text('');
            }
          }),
    );
  }
}
