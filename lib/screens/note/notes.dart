import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:git_explorer/screens/note/add_note.dart';
import 'package:git_explorer/screens/note/viewNotes.dart';
import 'package:git_explorer/screens/note/gitIntro.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');

  List<Color> myColors = [
    Colors.amber.shade300,
    Colors.tealAccent.shade100,
    Colors.lightBlue.shade300,
    Colors.orange.shade300,
    Colors.pinkAccent.shade100,
    Colors.lightGreen.shade300,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff251F34),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context)
      //         .push(
      //       MaterialPageRoute(
      //         builder: (context) => AddNote(),
      //       ),
      //     )
      //         .then((value) {
      //       print("Calling Set  State !");
      //       setState(() {});
      //     });
      //   },
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white70,
      //   ),
      //   backgroundColor: const Color(0xff14DAE2),
      // ),
      //
      appBar: AppBar(
        title: Text(
          "Notes"
        ),
        backgroundColor: const Color(0xff251F34),
      ),
      //
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.docs.length == 0) {
              return const Center(
                child: Text(
                  "No notes available",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                Random random = new Random();
                Color bg = myColors[random.nextInt(4)];
                Map? data = snapshot.data?.docs[index].data() as Map?;
                DateTime myDateTime = data!['created']?.toDate();
                String formattedTime =
                DateFormat.yMMMd().add_jm().format(myDateTime);

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        ViewNotes(data, formattedTime, snapshot.data!.docs[index].reference),),)
                    .then((value){
                      setState(() {

                      });
                    });
                  },
                  child: Card(
                    color: bg,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data['title']}" + " (${data['heading']})" ,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          //
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          else {
            return Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
    );
  }
}