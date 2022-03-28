import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewNotes extends StatefulWidget {

  final Map data;
  final String time;
  final DocumentReference ref;

  ViewNotes(this.data, this.time, this.ref);

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  String? title;
  String? des;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                  "Update Note"
              ),
              backgroundColor: const Color(0xff251F34),
            ),
            backgroundColor: const Color(0xff251F34),
            floatingActionButton: FloatingActionButton(
              onPressed: update,
              child: Icon(Icons.save_rounded),
              backgroundColor: const Color(0xff14DAE2),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: delete,
                          child: Icon(
                            Icons.delete_forever,
                            size: 24.0,
                          ),
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
                    SizedBox(
                      height: 12.0,
                    ),
                    Form(key: key, child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Tittle",
                            hintStyle: TextStyle(color: Colors.grey)
                          ),
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          initialValue: widget.data['title'],
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
                            decoration: InputDecoration.collapsed(
                              hintText: "Note Description",
                              hintStyle: TextStyle(color: Colors.grey)
                            ),
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                            initialValue: widget.data['description'],
                            onChanged: (_val){
                              des = _val;
                            },
                            maxLines: 200,
                            validator: (_val){
                              if(_val!.isEmpty){
                                return "Input field cannot be empty!";
                              }else{
                                return null;
                              }
                            },
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

  void update() async{
    if(key.currentState!.validate()){
      await widget.ref.update({
        'title' : title,
        'description' : des
      });
      Navigator.pop(context);
    }
  }
  void delete() async{
    await widget.ref.delete();
    Navigator.pop(context);
  }

}
