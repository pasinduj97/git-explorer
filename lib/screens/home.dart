import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:git_explorer/screens/forums/forum.dart';
import 'package:git_explorer/screens/note/notes.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;
  final List<Widget> _children = [
    Forum(),
    Notes()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    String? name = FirebaseAuth.instance.currentUser?.displayName.toString();
    return  Scaffold(
      backgroundColor: Color(0xff251F34),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     FirebaseFirestore.instance
        //         .collection('categories')
        //         .add({'timestamp': Timestamp.fromDate(DateTime.now())});
        //   },
        //   child: Icon(Icons.add),
        // ),
        // body: StreamBuilder(
        //   stream:
        //   FirebaseFirestore.instance.collection('categories').snapshots(),
        //   builder: (BuildContext context,
        //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        //     if(!snapshot.hasData) return const SizedBox.shrink();
        //     return ListView.builder(itemCount: snapshot.data?.docs.length,itemBuilder: (BuildContext context, int index){
        //       final docData = snapshot.data?.docs[index].data();
        //       final dateTime = (docData!['timestamp'] as Timestamp).toDate();
        //       return ListTile(
        //         title: Text(dateTime.toString(), style: TextStyle(color: Colors.white),),
        //       );
        //     });
        //   },
        // ),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Learning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'My Notes',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff14DAE2),
        onTap: _onItemTapped,
        backgroundColor: Color(0xff251F34),
        unselectedItemColor: Colors.white ,
      ),
      );
  }
}
