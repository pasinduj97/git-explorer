import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/services/forum_methods.dart';
import 'package:intl/intl.dart';

class SolutionCard extends StatefulWidget {
  final snap;
  final questionId;

  const SolutionCard({Key? key, this.snap, this.questionId}) : super(key: key);

  @override
  State<SolutionCard> createState() => _SolutionCardState();
}

class _SolutionCardState extends State<SolutionCard> {
  bool upvoted = false;
  bool downvoted = false;

  getVoted() async {
    DocumentSnapshot doc = await ForumMethods().getVoted(
        solutionId: widget.snap['solutionId'].toString(),
        questionId: widget.questionId);

    if (doc.get("type").toString() == "downvote") {
      setState(() {
        downvoted = true;
        upvoted = false;
      });
    } else if (doc.get("type").toString() == "upvote") {
      setState(() {
        upvoted = true;
        downvoted = false;
      });
    }
  }

  @override
  void initState() {
    getVoted();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey))),
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Column(
            children: [
              !upvoted
                  ? IconButton(
                      onPressed: () async {
                        await ForumMethods().voteSolution(
                            votes: widget.snap['votes'],
                            solutionId: widget.snap['solutionId'].toString(),
                            questionId: widget.questionId,
                            type: "upvote");

                        getVoted();
                      },
                      icon: const Icon(
                        Icons.arrow_drop_up,
                        color: Colors.grey,
                      ))
                  : IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.file_download_done,
                        color: Colors.greenAccent,
                      )),
              Text(
                widget.snap['votes'].toString(),
                style: const TextStyle(color: Colors.grey),
              ),
              !downvoted
                  ? IconButton(
                      onPressed: () async {
                        await ForumMethods().voteSolution(
                            votes: widget.snap['votes'],
                            solutionId: widget.snap['solutionId'].toString(),
                            questionId: widget.questionId,
                            type: "downvote");

                        getVoted();
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ))
                  : IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.file_download_done,
                        color: Colors.greenAccent,
                      )),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              widget.snap.data()['userProfilePic'],
                            ),
                            radius: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.snap.data()['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    DateFormat.yMMMd().format(
                                      widget.snap
                                          .data()['datePublished']
                                          .toDate(),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    widget.snap['uid'].toString() ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? IconButton(
                            onPressed: () async {
                              await ForumMethods().deleteSolution(
                                  widget.snap['solutionId'].toString(),
                                  widget.questionId);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red))
                        : Container(),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Text(' ${widget.snap.data()['text']}',
                      textAlign: TextAlign.start,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 19)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
