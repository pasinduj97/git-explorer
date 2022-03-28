import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: add,
                        child: Text('Save', style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.cyan
                            ),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                              horizontal: 25.0,
                              vertical: 8.0
                            ))
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Form(key: key, child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration.collapsed(
                          hintText: "Tittle",
                          hintStyle: TextStyle(color: Colors.grey)
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
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextFormField(
                          decoration: const InputDecoration.collapsed(
                            hintText: "Note Description",
                            hintStyle: TextStyle(color: Colors.grey)
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
                          maxLines: 20,
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
