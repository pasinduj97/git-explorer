import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/Models/Mark.dart';
import 'package:git_explorer/screens/certificates/certificate_listing.dart';
import 'package:git_explorer/screens/certificates/certificate_view.dart';
import 'package:git_explorer/screens/certificates/course_info.dart';
import 'package:git_explorer/services/certificate_methods.dart';

class Certificate extends StatefulWidget {
  const Certificate({Key? key}) : super(key: key);

  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  List selected = [];
  bool _isLoading = false;

  bool getSelected(id) {
    bool response = false;
    for (var element in selected) {
      if (element.id == id && element.selected == true) {
        response = true;
        break;
      }
    }

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff251F34),
        appBar: AppBar(
          backgroundColor: const Color(0xff251F34),
          title: const Text("Certificate"),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot != null) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, index) {
                              if (snapshot.data!.docs[index].get('name') ==
                                      'Certificates' ||
                                  snapshot.data!.docs[index].get('name') ==
                                      'Forum') {
                                return Container();
                              }
                              ;

                              return Container(
                                  margin: EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    child: Container(
                                        margin: EdgeInsets.all(2.0),
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white70),
                                        child: CheckboxListTile(
                                          title: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CourseInfo(
                                                              subCategoryId:
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .reference
                                                                      .id,
                                                              subCategoryName:
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          'name'),
                                                            )));
                                              },
                                              child: Text(snapshot
                                                  .data!.docs[index]
                                                  .get('name'))),
                                          subtitle: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CourseInfo(
                                                              subCategoryId:
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .reference
                                                                      .id,
                                                              subCategoryName:
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          'name'),
                                                            )));
                                              },
                                              child: StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('categories')
                                                      .doc(snapshot
                                                          .data!
                                                          .docs[index]
                                                          .reference
                                                          .id)
                                                      .collection(
                                                          "lessonCompletePercentage")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid
                                                          .toString())
                                                      .snapshots(),
                                                  builder: (context,
                                                      AsyncSnapshot<
                                                              DocumentSnapshot<
                                                                  Map<String,
                                                                      dynamic>>>
                                                          snap) {
                                                    if (snap.data?.exists ??
                                                        false) {
                                                      selected.add(Marks(
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                              .reference
                                                              .id,
                                                          snap.data!
                                                              .get("completed"),
                                                          false));
                                                      return (Text(snap.data!
                                                          .get("completed")
                                                          .toString()));
                                                    } else {
                                                      return Text('');
                                                    }
                                                  })),
                                          autofocus: false,
                                          activeColor: Colors.black54,
                                          checkColor: Colors.white,
                                          selected: getSelected(snapshot
                                              .data!.docs[index].reference.id),
                                          value: getSelected(snapshot
                                              .data!.docs[index].reference.id),
                                          onChanged: (value) {
                                            if (value != null &&
                                                value == true) {
                                              setState(() {
                                                for (var element in selected) {
                                                  if (element.id ==
                                                      snapshot.data!.docs[index]
                                                          .reference.id) {
                                                    element.selected = true;
                                                  }
                                                }
                                              });
                                              log(selected.length.toString());
                                            }

                                            if (value != null &&
                                                value == false) {
                                              log(snapshot.data!.docs[index]
                                                  .reference.id);
                                              setState(() {
                                                selected.removeWhere((item) =>
                                                    item.id ==
                                                    snapshot.data!.docs[index]
                                                        .reference.id);
                                              });
                                              log(selected.length.toString());
                                            }
                                          },
                                        )),
                                  ));
                            });
                      } else {
                        return const Text('');
                      }
                    }),
              ),
              InkWell(
                onTap: () async {
                  String marks = await CertificateMethods()
                      .createCertificate(data: selected);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CertificateView(marks: marks)));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 7, right: 7),
                  child: !_isLoading
                      ? const Text(
                          'Generate Certificate',
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
              InkWell(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CertificateListing()));
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 7, right: 7, top: 15),
                  child: !_isLoading
                      ? const Text(
                          'My Certificates',
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
        ));
  }

}
