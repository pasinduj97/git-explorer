import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/rounded_btn.dart';
import '../../services/storage_methods.dart';
import 'login.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String username;
  Uint8List? _image;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Image Selected');
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff251F34),
        ),
        backgroundColor: Color(0xff251F34),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  'Create Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Please fill the input below.',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                  backgroundColor: Colors.red,
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      'https://i.stack.imgur.com/l60Hf.png'),
                                  backgroundColor: Colors.red,
                                ),
                          Positioned(
                            bottom: -10,
                            left: 80,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Text(
                      'Username',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: (const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3B324E),
                        filled: true,
                        prefixIcon: Image.asset('images/icon_email.png'),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff14DAE2), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      onChanged: (value) {
                        username = value;
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    const Text(
                      'E-mail',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: (const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3B324E),
                        filled: true,
                        prefixIcon: Image.asset('images/icon_email.png'),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff14DAE2), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Password',
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: (const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                      obscureText: true,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3B324E),
                        filled: true,
                        prefixIcon: Image.asset('images/icon_lock.png'),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff14DAE2), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: showSpinner
                      ? const CircularProgressIndicator(color: Colors.white)
                      : RoundedButton(
                          btnText: 'SIGN UP',
                          color: Color(0xff14DAE2),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });
                            try {
                              UserCredential cred =
                                  await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              String photoUrl =
                                  'https://i.stack.imgur.com/l60Hf.png';

                              if (_image != null) {
                                photoUrl = await StorageMethods()
                                    .uploadUserProdile(_image!, cred.user!.uid);
                              }

                              await _firestore
                                  .collection("users")
                                  .doc(cred.user!.uid)
                                  .set({
                                "username": username,
                                "uid": cred.user!.uid,
                                "photoUrl": photoUrl,
                              });

                              setState(() {
                                showSpinner = false;
                                username = '';
                                email = '';
                                password = '';
                                _image = null;
                              });
                            } catch (e) {
                              print(e);
                            }
                            // Add login code
                          },
                        ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                        color: Colors.grey[600], fontWeight: FontWeight.w400),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: const Text('Sign in',
                        style: TextStyle(
                          color: Color(0xff14DAE2),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
