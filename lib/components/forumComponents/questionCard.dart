import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:git_explorer/services/forum_methods.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          // border: Border.all(
          //   // color: Color.fromRGBO(0, 0, 0, 1),
          // ),
          // color: Color.fromRGBO(0, 0, 0, 1),
          ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      NetworkImage(widget.snap['image'].toString()),
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
                            fontWeight: FontWeight.bold,
                          ),
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
                                          questionId: widget.snap["questionId"].toString(),
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
                    : Container(),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              // FireStoreMethods().likePost(
              //   widget.snap['postId'].toString(),
              //   user.uid,
              //   widget.snap['likes'],
              // );
              // setState(() {
              //   isLikeAnimating = true;
              // });
            },
            child: Stack(
              alignment: Alignment.center,
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
                // AnimatedOpacity(
                //   duration: const Duration(milliseconds: 200),
                //   opacity: isLikeAnimating ? 1 : 0,
                //   child: LikeAnimation(
                //     isAnimating: isLikeAnimating,
                //     child: const Icon(
                //       Icons.favorite,
                //       color: Colors.white,
                //       size: 100,
                //     ),
                //     duration: const Duration(
                //       milliseconds: 400,
                //     ),
                //     onEnd: () {
                //       setState(() {
                //         isLikeAnimating = false;
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      children: [
                        TextSpan(text: widget.snap['question'].toString()),
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
          )
        ],
      ),
    );
  }
}
