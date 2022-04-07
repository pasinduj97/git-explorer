import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:git_explorer/services/rating_methods.dart';

class RatingButton extends StatefulWidget {
  final String lessonId;
  final String subCategoryId;
  final bool isUserRated;
  final double currentUserRating;
  final String currentUserComment;

  const RatingButton({
    Key? key,
    required this.lessonId,
    required this.isUserRated,
    required this.subCategoryId,
    required this.currentUserRating,
    required this.currentUserComment,
  }) : super(key: key);

  @override
  State<RatingButton> createState() => _RatingButtonState();
}

class _RatingButtonState extends State<RatingButton> {
  late FirebaseAuth _auth = FirebaseAuth.instance;

  late TextEditingController controller;

  double currentUserRating = 0.0;
  String currentUserComment = '';
  String buttonDisplayText = 'Add Your Rating';
  bool isUserRated = false;

  @override
  void initState() {
    super.initState();
    print('user widget.isUserRated ');
    print(widget.isUserRated);
    if (widget.isUserRated) {
      setState(() {
        currentUserRating = widget.currentUserRating;
        currentUserComment = widget.currentUserComment;
        buttonDisplayText = 'Update Your Rating';
        isUserRated = widget.isUserRated;
      });
      controller = TextEditingController(text: widget.currentUserComment);
    } else {
      controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('RatingButton dispose');
  }

  onRatingSubmit() async {
    // Navigator.of(context).pop();
    if (isUserRated) {
      await RatingMethods().updateRating(
          comment: controller.text,
          userId: _auth.currentUser!.uid,
          rating: currentUserRating,
          subCategoryId: widget.subCategoryId,
          lessonId: widget.lessonId);
      controller.clear();
    } else {
      await RatingMethods().postRating(
          comment: controller.text,
          rating: currentUserRating,
          subCategoryId: widget.subCategoryId,
          lessonId: widget.lessonId);
    }
  }

  onRatingDetele() async {
    // Navigator.of(context).pop();
    await RatingMethods().deleteRating(
        userId: _auth.currentUser!.uid,
        subCategoryId: widget.subCategoryId,
        lessonId: widget.lessonId);
    controller.clear();
  }

  Future<String?> showRatingDialog(context) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Rate this Post'),
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
                    // setState(() {
                    currentUserRating = rating;
                    // });
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
              TextField(
                controller: controller,
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
              ),
            ],
          ),
          actions: <Widget>[
            if (isUserRated)
              TextButton(
                child: const Text('Delete'),
                onPressed: () {
                  onRatingDetele();
                  Navigator.of(context).pop('delete');
                },
              ),
            TextButton(
                child: Text(isUserRated ? 'Update' : 'Submit'),
                onPressed: () {
                  onRatingSubmit();
                  Navigator.of(context).pop(isUserRated ? 'Update' : 'Submit');
                }),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final action = await showRatingDialog(context);

        if (action == 'delete') {
          setState(() {
            buttonDisplayText = 'Add Your Rating';
          });
        } else {
          setState(() {
            buttonDisplayText = 'Update Your Rating';
          });
        }
        // _displayTextInputDialog(context);
      },
      child: Text(buttonDisplayText),
    );
  }
}
