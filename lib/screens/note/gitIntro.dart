import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/screens/note/add_note.dart';

class GitIntro extends StatefulWidget {
  const GitIntro({Key? key}) : super(key: key);

  @override
  State<GitIntro> createState() => _GitIntroState();
}

class _GitIntroState extends State<GitIntro> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff251F34),
      appBar: AppBar(
        title: const Text(
            "Git Intro"
        ),
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
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => AddNote(),
                          ),
                        ).then((value) {
                          print("Calling Set  State !");
                          setState(() {});
                        });
                        // Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.cyan
                        ),
                      ),
                      child: const Text('QA', style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => AddNote(),
                          ),
                        ).then((value) {
                          print("Calling Set  State !");
                          setState(() {});
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.cyan
                        ),
                      ),
                      child: const Text('Make Note', style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),),
                    ),
                  ]
                ),
                SizedBox(
                  height: 16.0,
                ),
                Container(child: Column(
                  children: [
                    const Text(
                      "Heading",
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      padding: const EdgeInsets.only(top: 12.0),
                      child: const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),

                      ),
                    ),
                  ],
                ))
              ],
          ),
        ),
      )
    );
  }
}
