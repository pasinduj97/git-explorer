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
  bool edit = false;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                  "My Note"
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
                          enabled: edit,
                          initialValue: widget.data['title'],
                          onChanged: (_val){
                            title = _val;
                          },
                          maxLines: 1,
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
                          initialValue: widget.data['description'],
                          onChanged: (_val){
                            des = _val;
                          },
                          enabled: edit,
                          maxLines: 8,
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
                          onPressed: delete,
                          child: const Icon(
                            Icons.delete_forever,
                            size: 24.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            onPrimary: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            minimumSize: Size(400, 40),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (){
                            setState(() {
                              edit = !edit;
                            });
                          },
                          child: const Icon(
                            Icons.edit,
                            size: 24.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.cyan,
                            onPrimary: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            minimumSize: Size(400, 40),
                          ),
                        ),
                        Container(
                          child: edit ? ElevatedButton(
                            onPressed: update,
                            child:  const Text('Save', style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.cyan,
                              onPrimary: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              minimumSize: Size(400, 40),
                            ),
                          ) : null,
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
