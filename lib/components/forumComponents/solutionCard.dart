import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SolutionCard extends StatelessWidget {
  final snap;

  const SolutionCard({Key? key, this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff251F34),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['userProfilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: snap.data()['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        TextSpan(
                            text: ' ${snap.data()['text']}',
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        snap.data()['datePublished'].toDate(),
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
          ),
        ],
      ),
    );
  }
}
