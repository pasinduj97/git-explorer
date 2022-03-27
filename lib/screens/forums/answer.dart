import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/components/forumComponents/solutionCard.dart';
import 'package:git_explorer/services/forum_methods.dart';

class Answer extends StatefulWidget {
  final String questionId;
  final snap;

  const Answer({Key? key, this.questionId = '', this.snap}) : super(key: key);

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  final TextEditingController solutionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff251F34),
      appBar: AppBar(
        backgroundColor: const Color(0xff251F34),
        title: const Text("Solutions"),
      ),
      body: Column(
        children: [
          Column(

            children: [
              widget.snap['image'] != ''
                  ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                child: Image.network(
                  widget.snap['image'].toString(),
                  fit: BoxFit.cover,
                ),
              )
                  : const SizedBox(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                      children: [
                        TextSpan(text: widget.snap['question'].toString()),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('questions')
                  .doc(widget.questionId)
                  .collection('solutions')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => SolutionCard(
                    snap: snapshot.data!.docs[index],
                    questionId: widget.questionId,
                  ),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
               CircleAvatar(
                backgroundImage: NetworkImage(
                widget.snap['userProfilePic'].toString()
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    cursorColor: Colors.white,
                    controller: solutionController,
                    style: (const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400
                    )),
                    decoration: const InputDecoration(
                      hintText: 'Add solution',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey)

                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  try {
                    String res = await ForumMethods().postSolution(
                      widget.questionId,
                      solutionController.text,
                    );

                    setState(() {
                      solutionController.text = "";
                    });
                  } catch (err) {
                    log(err.toString());
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Color(0xff14DAE2),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
