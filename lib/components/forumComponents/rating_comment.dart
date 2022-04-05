import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:git_explorer/services/forum_methods.dart';
import 'package:intl/intl.dart';

class RatingComment extends StatefulWidget {
  final rating;
  final comment;
  final date;
  final id;

  RatingComment({
    Key? key,
    required this.rating,
    required this.comment,
    required this.date,
    required this.id,
  }) : super(key: key);
  State<RatingComment> createState() => _RatingCommentState();
}

class _RatingCommentState extends State<RatingComment> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String profileImage = '';
  String userName = '';

  getUser() async {
    DocumentSnapshot user =
        await _firestore.collection('users').doc(widget.id).get();

    Map<String, dynamic> userData = user.data() as Map<String, dynamic>;
    if (userData != null) {
      setState(() {
        profileImage = userData['photoUrl'] != null
            ? userData['photoUrl']
            : 'https://i.stack.imgur.com/l60Hf.png';
        userName = userData['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
                radius: 18,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              DateFormat.yMMMd().format(widget.date),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                          )
                        ],
                      ))),
              RatingBar.builder(
                initialRating: widget.rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.blue,
                ),
                onRatingUpdate: (r) {},
              )
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: Text(widget.comment,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Divider(),
        ],
      ),
    );
  }
}
