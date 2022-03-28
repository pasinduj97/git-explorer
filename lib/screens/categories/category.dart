import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:git_explorer/screens/categories/sub_categories.dart';
import 'package:git_explorer/screens/certificates/certificate.dart';

import '../forums/forum.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff251F34),
        appBar: AppBar(
          backgroundColor: const Color(0xff251F34),
          title: const Text("My Learnings"),
        ),
        body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot != null) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
                itemBuilder: (ctx, index) => Container(
                    child: GestureDetector(
                  onTap: () {
                    if (snapshot.data!.docs[index].get('name') ==
                        'Certificates') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Certificate()));
                    } else if (snapshot.data!.docs[index].get('name') ==
                        'Forum') {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Forum()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubCategory(
                                  subCategoryId:
                                      snapshot.data!.docs[index].reference.id,
                                  subCategoryName:
                                  snapshot.data!.docs[index].get('name')
                              )));
                    }
                  },
                  child: Container(
                      width: 160,
                      height: 160,
                      margin: EdgeInsets.all(15.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white70),
                      child: Center(
                          child: Text(
                        snapshot.data!.docs[index].get('name'),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ))),
                )),
              );
            } else {
              return const Text('');
            }
          },
        ));
  }
}
