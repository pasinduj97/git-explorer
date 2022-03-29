import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:git_explorer/services/forum_methods.dart';
import 'package:intl/intl.dart';

class RatingComment extends StatelessWidget {
  final ratingDoc;
  final comment;

  const RatingComment({
    Key? key,
    required this.ratingDoc,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                radius: 18,
              ),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10, top: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Avishka Shyaman',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '12/03/2022',
                              // DateFormat.yMMMd().format(
                              //   widget.snap.data()['datePublished'].toDate(),
                              // ),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                          )
                        ],
                      ))),
              RatingBar.builder(
                initialRating: ratingDoc.toDouble(),
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
            child: Text(comment,
                textAlign: TextAlign.start,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Divider(),
        ],
      ),
    );
  }
}
