import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/screens/forums/answer.dart';
import 'package:git_explorer/services/forum_methods.dart';
import 'package:intl/intl.dart';

import '../../screens/forums/add_question.dart';

class QuestionCard extends StatefulWidget {
  final snap;

  const QuestionCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xff251F34),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 7,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage(widget.snap['userProfilePic'].toString()),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.snap['username'].toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() ==
                        FirebaseAuth.instance.currentUser!.uid
                    ? Row(
                        children: <Widget>[
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddQuestionScreen(
                                              question: widget.snap["question"]
                                                  .toString(),
                                              editMode: true,
                                              questionId: widget
                                                  .snap["questionId"]
                                                  .toString(),
                                            )));
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              )),
                          IconButton(
                              onPressed: () async {
                                await ForumMethods().deleteQuestion(
                                    widget.snap['questionId'].toString());
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              )),
                        ],
                      )
                    : SizedBox(height: 50),
              ],
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                widget.snap['image'] != ''
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width*0.95,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            widget.snap['image'].toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Answer(
                              questionId: widget.snap['questionId'].toString(),
                              snap: widget.snap,
                            )));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                        children: [
                          TextSpan(
                              text: widget.snap['question'].toString(),
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['timestamp'].toDate()),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
