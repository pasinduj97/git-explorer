import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PostRating extends StatefulWidget {
  const PostRating({Key? key}) : super(key: key);

  @override
  State<PostRating> createState() => _PostRatingState();
}

class _PostRatingState extends State<PostRating> {
  double rating = 3.0;

  onRatingUpdate(rating) {
    // ignore: avoid_print
    print(rating);
    setState(() {
      this.rating = rating;
    });
  }

  showRatingDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Rate this Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tell others what you think'),
              const SizedBox(
                height: 32,
              ),
              Center(
                  child: RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.blue,
                ),
                onRatingUpdate: onRatingUpdate,
              ))
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 8,
        ),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 8,
                ),
                child: const Text('Rating and Reviews',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ))),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 8,
                left: 10,
                right: 10,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$rating",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 38,
                                  color: Colors.white,
                                )),
                            RatingBar.builder(
                              initialRating: rating,
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
                              onRatingUpdate: onRatingUpdate,
                            ),
                            Text("  Votes: 1,000",
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
                            child: const Text('Add Your Rating'),
                          ),
                          RatingBar.builder(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 15.0,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.blue,
                            ),
                            onRatingUpdate: onRatingUpdate,
                          )
                        ])
                  ]),
            )
          ],
        ));
  }
}
