import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/screens/note/gitIntro.dart';

class SubCategory extends StatefulWidget {
  final String subCategoryId;
  final String subCategoryName;

  const SubCategory(
      {Key? key, required this.subCategoryId, required this.subCategoryName})
      : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff251F34),
        appBar: AppBar(
          backgroundColor: const Color(0xff251F34),
          title: Text(widget.subCategoryName),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('categories')
                .doc((widget.subCategoryId).toString())
                .collection((widget.subCategoryId).toString())
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot != null) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      if (snapshot.data!.docs[index].get('name') ==
                              'Certificates' ||
                          snapshot.data!.docs[index].get('name') == 'Forum') {
                        return Container();
                      }

                      return Container(
                          margin: EdgeInsets.all(5.0),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GitIntro(
                                            categoryId: widget.subCategoryId,
                                            heading: snapshot.data!.docs[index]
                                                .get('name'),
                                            lessonId: snapshot
                                                .data!.docs[index].reference.id,
                                            description: snapshot
                                                .data!.docs[index]
                                                .get('description'))));
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(2.0),
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white70),
                                  child: Text(
                                      snapshot.data!.docs[index].get('name'),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)))));
                    });
              } else {
                return const Text('');
              }
            }));
  }
}
