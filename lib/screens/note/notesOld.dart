// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:git_explorer/screens/note/add_note.dart';
//
// class Notes extends StatefulWidget {
//   const Notes({Key? key}) : super(key: key);
//
//   @override
//   _NotesState createState() => _NotesState();
// }
//
// class _NotesState extends State<Notes> {
//
//   CollectionReference ref = FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .collection('notes');
//
//   List<Color> myColors = [
//     Colors.yellow.shade200,
//     Colors.red.shade200,
//     Colors.green.shade200,
//     Colors.deepPurple.shade200,
//     Colors.purple.shade200,
//     Colors.cyan.shade200,
//     Colors.teal.shade200,
//     Colors.tealAccent.shade200,
//     Colors.pink.shade200,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.of(context).push(
//            MaterialPageRoute(builder: (context) => AddNote(),
//            )
//          );
//        },
//        child: Icon(
//          Icons.add,
//          color: Colors.white,
//        ),
//        backgroundColor: Colors.grey[700],
//      ),
//       body: FutureBuilder<QuerySnapshot>(
//           future: ref.get(),
//           builder: (context, snapshot) {
//           if(snapshot.hasData){
//             return ListView.builder(
//               itemCount: snapshot.data?.docs.length,
//               itemBuilder:  (context, index) {
//                 Random random = new Random();
//                 Color bg = myColors[random.nextInt(4)];
//                 // Map data = snapshot.data.docs[index].data();
//                 return Card(
//                   color: bg,
//                   child: Column(
//                     children: [
//                       Text(
//                         "${snapshot.data.docs[index].data()}",
//                         style: TextStyle(
//                           fontSize: 24.0,
//                           fontFamily: "lato",
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             );
//           }else{
//             return Center(child: Text("Loading"),);
//           }
//
//       }),
//     );
//   }
// }
