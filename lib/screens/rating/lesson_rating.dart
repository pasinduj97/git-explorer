import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_explorer/components/forumComponents/rating_comment.dart';
import 'package:git_explorer/screens/rating/rating_button.dart';

class LessonRating extends StatefulWidget {
  final snap;
  final String lessonId;
  final String subCategoryId;

  const LessonRating({
    Key? key,
    required this.snap,
    required this.lessonId,
    required this.subCategoryId,
  }) : super(key: key);

  @override
  State<LessonRating> createState() => _LessonRatingState();
}

class _LessonRatingState extends State<LessonRating> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double allRating = 0;
  bool isUserRated = false;
  double currentUserRating = 0.0;
  String currentUserComment = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onRatingUpdate(rating) {
    setState(() {
      allRating = rating;
    });
  }

  @override
  Widget build(BuildContext context) {
    final numberOfRating = widget.snap.length;
    setState(() {
      allRating = 0.0;
      isUserRated = false;
    });

    if (numberOfRating > 0) {
      double sumOfAllRating = 0.0;
      for (var rateRowItem in widget.snap) {
        if (_auth.currentUser!.uid == rateRowItem.reference.id) {
          setState(() {
            currentUserRating = rateRowItem.get('rating').toDouble();
            currentUserComment = rateRowItem.get('comment');
            isUserRated = true;
          });
        }

        if (rateRowItem.get('rating') != null) {
          sumOfAllRating += rateRowItem.get('rating');
        }
      }

      setState(() {
        allRating = sumOfAllRating / numberOfRating;
      });
    }

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                child: const Text('Rating and Reviews',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${double.parse((allRating).toStringAsFixed(1))}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 38,
                                  color: Colors.white,
                                )),
                            RatingBar.builder(
                              initialRating: allRating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 30.0,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                              onRatingUpdate: (rating) {},
                            ),
                            Text("  Votes: ${widget.snap.length}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 163, 163, 163),
                                ))
                          ]),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RatingButton(
                              lessonId: widget.lessonId,
                              isUserRated: isUserRated,
                              subCategoryId: widget.subCategoryId,
                              currentUserRating: currentUserRating,
                              currentUserComment: currentUserComment)
                        ])
                  ]),
            ),
            for (final ratingRowItem in widget.snap)
              RatingComment(
                  rating: ratingRowItem.get('rating'),
                  date: ratingRowItem.get('timestamp').toDate(),
                  id: ratingRowItem.reference.id,
                  comment: ratingRowItem.get('comment')),
          ],
        ));
  }
}
