import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:git_explorer/screens/home.dart';
import '../../components/rounded_btn.dart';
import 'login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:username_gen/username_gen.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          leading: _goBackButton(context),
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
                child: Text('Create Account',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 25
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Please fill the input below.',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                      fontSize: 14
                  ),),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'E-mail',
                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: (const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      )),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3B324E),
                        filled: true,
                        prefixIcon: Image.asset('images/icon_email.png'),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
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
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: (const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400
                      )),
                      obscureText: true,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3B324E),
                        filled: true,
                        prefixIcon: Image.asset('images/icon_lock.png'),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff14DAE2), width: 2.0),
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
                  child: RoundedButton(
                    btnText: 'SIGN UP',
                    color: Color(0xff14DAE2),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final newUser =
                        await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);

                        if (newUser != null) {
                          await _auth.currentUser?.updateDisplayName(UsernameGen().generate());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        }

                        setState(() {
                          showSpinner = false;
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
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account?',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400
                    ),),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
                    },
                    child: const Text('Sign in',
                        style: TextStyle(
                          color: Color(0xff14DAE2),)
                    ),
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

Widget _goBackButton(BuildContext context) {
  return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.grey[350]),
      onPressed: () {
        Navigator.of(context).pop(true);
      });
}
