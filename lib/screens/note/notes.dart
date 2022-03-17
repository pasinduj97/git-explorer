import 'package:flutter/material.dart';
import 'package:git_explorer/screens/note/add_note.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     floatingActionButton: FloatingActionButton(
       onPressed: () {
         Navigator.of(context).push(
           MaterialPageRoute(builder: (context) => AddNote(),
           )
         );
       },
       child: Icon(
         Icons.add,
         color: Colors.white,
       ),
       backgroundColor: Colors.grey[700],
     ),body: Center(
      child: Text("Note"),
    ),
    );
  }
}
