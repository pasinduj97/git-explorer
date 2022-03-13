import 'dart:developer';

import 'package:flutter/material.dart';

class QuestionCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const QuestionCard({Key? key,  required this.snap,}) : super(key: key);

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
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=998&q=80"
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                      Text(
                         'TestUser',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                true
                    ? IconButton(
                  onPressed: () {
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                                'Edit'
                              ]
                                  .map(
                                    (e) => InkWell(
                                    child: Container(
                                      padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16),
                                      child: Text(e),
                                    ),
                                    onTap: () {
                                      log(e);
                                      // remove the dialog box
                                      Navigator.of(context).pop();
                                    }),

                              )
                                  .toList()),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    "https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=998&q=80",
                    fit: BoxFit.cover,
                  ),
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
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
                      children: [
                        TextSpan(
                          text: 'lorem ipsum',
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: const Text(
                    // DateFormat.yMMMd()
                    //     .format(widget.snap['datePublished'].toDate()),
                    '2014-2-3',
                    style: TextStyle(
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
