import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CertificateTemplate extends StatefulWidget {
  const CertificateTemplate({Key? key}) : super(key: key);

  @override
  _CertificateTemplateState createState() => _CertificateTemplateState();
}

class _CertificateTemplateState extends State<CertificateTemplate> {
  List selected = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff251F34),
        appBar: AppBar(
          backgroundColor: const Color(0xff251F34),
          title: const Text("My Certificate"),
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
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      if (snapshot.data!.docs[index].get('name') == 'Certificates' || snapshot.data!.docs[index].get('name') == 'Forum') {
                        return Container();
                      };

                      return Container(
                          margin: EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                                margin: EdgeInsets.all(2.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white70),
                                child: CheckboxListTile(
                                  title: Text(snapshot.data!.docs[index].get('name')),
                                  subtitle: Text(getCompletion()),
                                  autofocus: false,
                                  activeColor: Colors.green,
                                  checkColor: Colors.white,
                                  selected: false,
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                    });
                                  },
                                )),
                          ));
                    }
                );
              } else {
                return const Text('');
              }
            }));
  }

  String getCompletion() {
    return '80% completed';
  }
}
