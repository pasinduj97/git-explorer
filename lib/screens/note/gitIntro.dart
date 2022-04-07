import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/components/forumComponents/rating_comment.dart';
import 'package:git_explorer/screens/note/add_note.dart';
import 'package:git_explorer/screens/rating/lesson_rating.dart';

class GitIntro extends StatefulWidget {
  final String categoryId;
  final String heading;
  final String description;
  final String lessonId;

  const GitIntro(
      {Key? key,
      required this.categoryId,
      required this.heading,
      required this.description,
      required this.lessonId})
      : super(key: key);

  @override
  State<GitIntro> createState() => _GitIntroState();
}

class _GitIntroState extends State<GitIntro> {
  CollectionReference ref = FirebaseFirestore.instance.collection('categories');
  bool completed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    completeState();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!completed) {
        add();
      }
      completeState();
    });
  }

  void completeState() async {
    bool result = await getCompleted();
    setState(() {
      completed = result;
    });
  }

  Future<bool> add() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection(widget.categoryId)
        .doc(widget.lessonId)
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .set({"isRead": true});

    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection("lessonCompletePercentage")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .get();

    Map<String, dynamic> value = docSnap.data() as Map<String, dynamic>;

    await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection("lessonCompletePercentage")
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .set({
      "completed":
         docSnap.data() != null ? value['completed'] + 20 : 20
    });

    return true;
    // .collection('users')
  }

  Future<bool> getCompleted() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection(widget.categoryId)
        .doc(widget.lessonId)
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
          title: const Text("Git Intro"),
          backgroundColor: const Color(0xff251F34),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      completed
                          ? ElevatedButton(
                              onPressed: () {
                                // Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.cyan),
                              ),
                              child: const Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox(
                              height: 0,
                            ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => AddNote(
                                  categoryId: widget.categoryId,
                                  heading: widget.heading),
                            ),
                          )
                              .then((value) {
                            print("Calling Set  State !");
                            setState(() {});
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.cyan),
                        ),
                        child: const Text(
                          'Make Note',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
                SizedBox(
                  height: 16.0,
                ),
                Container(
                    child: Column(
                  children: [
                    Text(
                      widget.heading,
                      style: const TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        widget.description,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      height: 30,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('categories')
                          .doc((widget.categoryId).toString())
                          .collection((widget.categoryId).toString())
                          .doc((widget.lessonId).toString())
                          .collection('ratings')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot != null) {
                          return LessonRating(
                              snap: snapshot.data!.docs,
                              subCategoryId: widget.categoryId.toString(),
                              lessonId: widget.lessonId.toString());
                        } else {
                          return const Text('No Rating...');
                        }
                      },
                    )
                  ],
                ))
              ],
            ),
          ),
        ));
  }
}
