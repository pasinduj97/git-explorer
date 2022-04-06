import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseInfo extends StatefulWidget {
  final String subCategoryId;
  final String subCategoryName;

  const CourseInfo({
    Key? key,
    required this.subCategoryId,
    required this.subCategoryName,
  }) : super(key: key);

  @override
  State<CourseInfo> createState() => _CourseInfoState();
}

class _CourseInfoState extends State<CourseInfo> {
  var completed;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // void completeState() async {
  //   bool result = await getCompleted();
  //   setState(() {
  //     completed = result;
  //   });
  // }

  Future<bool> getCompleted(lessonId) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.subCategoryId)
        .collection(widget.subCategoryId)
        .doc(lessonId)
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .get();

    Map<String, dynamic> data = snap.data() as Map<String, dynamic>;

    if (data['isRead'] != null && data['isRead']) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff251F34),
        appBar: AppBar(
          backgroundColor: const Color(0xff251F34),
          title: Text(widget.subCategoryName),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('categories')
                .doc((widget.subCategoryId).toString())
                .collection((widget.subCategoryId).toString())
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
                      return Container(
                          margin: const EdgeInsets.all(5.0),
                          child: Container(
                              margin: const EdgeInsets.all(2.0),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white70),
                              child: Row(
                                children: [
                                  Text(snapshot.data!.docs[index].get('name'),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  FutureBuilder<bool>(
                                      future: getCompleted(snapshot
                                          .data!.docs[index].reference.id),
                                      builder:
                                          (context, AsyncSnapshot<bool> snap) {
                                        if (snap.hasData && snap.data == true) {
                                          return const Icon(
                                            Icons.file_download_done,
                                            color: Colors.green,
                                          );
                                        } else {
                                          return Text('');
                                        }
                                      })
                                ],
                              )));
                    });
              } else {
                return const Text('');
              }
            }));
  }
}
