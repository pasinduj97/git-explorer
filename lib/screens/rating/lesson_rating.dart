import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_explorer/components/forumComponents/rating_comment.dart';
import 'package:git_explorer/services/rating_methods.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double allRating = 3.3;
  bool isUserRated = false;
  double currentUserRating = 0.0;
  String currentUserComment = '';

  onRatingUpdate(rating) {
    setState(() {
      allRating = rating;
    });
  }

  onRatingSubmit() async {
    if (isUserRated) {
      await RatingMethods().updateRating(
          comment: currentUserComment,
          userId: _auth.currentUser!.uid,
          rating: currentUserRating,
          subCategoryId: widget.subCategoryId,
          lessonId: widget.lessonId);
    } else {
      await RatingMethods().postRating(
          comment: currentUserComment,
          rating: currentUserRating,
          subCategoryId: widget.subCategoryId,
          lessonId: widget.lessonId);
    }
    Navigator.of(context).pop();
  }

  onRatingDetele() async {
    await RatingMethods().deleteRating(
        userId: _auth.currentUser!.uid,
        subCategoryId: widget.subCategoryId,
        lessonId: widget.lessonId);
    Navigator.of(context).pop();
  }

  showRatingDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Rate this Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tell others what you think'),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: currentUserRating,
                  minRating: 2,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.blue,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      currentUserRating = rating;
                    });
                  },
                ),
              ),
              const Align(
                child: Text(
                  "Enter your title: ",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(
                height: 12.0,
              ),
              TextFormField(
                controller: TextEditingController(text: currentUserComment),
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  filled: false,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                onChanged: (_val) {
                  // setState(() {
                  currentUserComment = _val;
                  // });
                },
                validator: (_val) {
                  if (_val!.isEmpty) {
                    return "Input field cannot be empty!";
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
          actions: <Widget>[
            if (isUserRated)
              TextButton(
                child: const Text('Delete'),
                onPressed: onRatingDetele,
              ),
            TextButton(
                child: Text(isUserRated ? 'Update' : 'Submit'),
                onPressed: onRatingSubmit),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final numberOfRating = widget.snap.length;
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

    print('rated');
    print(isUserRated);
    print(_auth.currentUser!.uid);

    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                // padding: const EdgeInsets.only(
                //   // left: 8,
                // ),
                child: const Text('Rating and Reviews',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 8,
                // left: 10,
                // right: 10,
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
                            Text("  Votes: $numberOfRating",
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
                          ElevatedButton(
                            onPressed: () {
                              showRatingDialog();
                            },
                            child: Text(
                                '${isUserRated ? 'Update' : 'Add'} Your Rating'),
                          ),
                          // RatingBar.builder(
                          //   initialRating: rating,
                          //   minRating: 1,
                          //   direction: Axis.horizontal,
                          //   allowHalfRating: true,
                          //   itemCount: 5,
                          //   itemSize: 15.0,
                          //   itemPadding:
                          //       const EdgeInsets.symmetric(horizontal: 1.0),
                          //   itemBuilder: (context, _) => const Icon(
                          //     Icons.star,
                          //     color: Colors.blue,
                          //   ),
                          //   onRatingUpdate: onRatingUpdate,
                          // )
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
