import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  final String categoryId;
  final String heading;

  const AddNote({Key? key, required this.categoryId, required this.heading}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String? title;
  String? des;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
                "Add Note"
            ),
            backgroundColor: const Color(0xff251F34),
          ),
          backgroundColor: const Color(0xff251F34),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Form(key: key, child: Column(
                    children: [
                      const Align(
                        child: Text(
                          "Enter your title: ",
                          style: TextStyle(fontSize: 18, color: Colors.cyan),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff3B324E),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        onChanged: (_val){
                          title = _val;
                        },
                        validator: (_val){
                          if(_val!.isEmpty){
                            return "Input field cannot be empty!";
                          }else{
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Align(
                        child: Text(
                          "Enter your description: ",
                          style: TextStyle(fontSize: 18, color: Colors.cyan),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      TextFormField(
                         maxLines: 8,
                         decoration: const InputDecoration(
                           border: InputBorder.none,
                           fillColor: Color(0xfff3B324E),
                           filled: true,
                           focusedBorder: OutlineInputBorder(
                             borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
                             borderRadius: BorderRadius.all(Radius.circular(20.0)),
                           ),
                          ),
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                          onChanged: (_val){
                            des = _val;
                          },
                          validator: (_val){
                            if(_val!.isEmpty){
                              return "Input field cannot be empty!";
                            }else{
                              return null;
                            }
                          },
                        ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      ElevatedButton(
                        onPressed: add,
                        child: const Text('Save', style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.cyan,
                          onPrimary: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          minimumSize: const Size(400, 40),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ))
      );
  }

  void add() async{
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');

    var data = {
      'categoryId': widget.categoryId,
      'heading': widget.heading,
      'title' : title,
      'description': des,
      'created': DateTime.now(),
    };

    if(key.currentState!.validate()){
      await ref.add(data);
      Navigator.pop(context);
    }
  }
}
