import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Certificate extends StatefulWidget {

  const Certificate({Key? key}) : super(key: key);


  isCertificateExist() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;


  }

  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List selected = [];

  Future<Map<String, dynamic>> getCertificate(uId) async {
    DocumentSnapshot doc = await _firestore
        .collection('certificates')
        .doc(uId)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // var doc = await _firestore
    //     .collection('certificates')
    //     .doc(uId)
    //     .get();x 
    print(data);
    return data;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff251F34),
        appBar: AppBar(
          backgroundColor: const Color(0xff251F34),
          title: const Text("Certificate"),
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
                  itemBuilder: (ctx, index)   {
                    if (snapshot.data!.docs[index].get('name') == 'Certificates' || snapshot.data!.docs[index].get('name') == 'Forum') {
                      return Container();
                    } else {
                      FutureBuilder(
                        future: getCertificate(_auth.currentUser!.uid.toString()),
                        builder: (BuildContext context, snapshot) {
                          if(snapshot.hasData){
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }else{
                              return Center( // here only return is missing
                                  child: Text('Hello')
                              );
                            }
                          }else if (snapshot.hasError){
                            Text('no data');
                          }
                          return CircularProgressIndicator();
                        },
                      );
                    }


                    return Container(
                      margin: EdgeInsets.all(5.0),
                      child: GestureDetector(
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
