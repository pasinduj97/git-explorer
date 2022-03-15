import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/components/forumComponents/questionCard.dart';
import 'package:git_explorer/screens/forums/add_question.dart';

class Forum extends StatefulWidget {
  const Forum({Key? key}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Forum"),),
      floatingActionButton: FloatingActionButton(onPressed: () {    Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddQuestionScreen())
      ); }, child: const Icon(Icons.add),),
      body: Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('questions').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if(snapshot != null) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, index) =>
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 1,
                      ),
                      child: QuestionCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    ),
              );
            }else{
              return const Text('');
            }
          },
        ),
      ),
    );
  }
}
