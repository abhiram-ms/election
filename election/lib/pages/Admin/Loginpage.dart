import 'package:election/pages/Admin/AdminHome.dart';
import 'package:election/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:election/pages/Admin/AdminRegister.dart';
import 'package:flutter/material.dart';

import '../../services/Pickelection.dart';

final User? user = Auth().currentuser;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errormessage = '';
  bool _isloading = false;

  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      _isloading = true;
    });
    try {
      //try
      //await and call metheod
      await Auth().signInwithEmailAndPassword(
          email: _controlleremail.text, password: _controllerpassword.text);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Pickelec(admin: true,)),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      //catch
      setState(() {
        errormessage = e.message; //stores error message to errormessage
      });
    }
    if (mounted) {
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isloading) {
      return const Scaffold(
        backgroundColor: Colors.cyan,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Login Admin",
            style: TextStyle(
                color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          color: Colors.cyan,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: TextField(
                          controller: _controlleremail,
                          decoration: const InputDecoration(
                              hintText: 'Emial',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))))),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: TextField(
                          controller: _controllerpassword,
                          decoration: const InputDecoration(
                              hintText: 'password',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))))),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_controllerpassword.text.isNotEmpty &&
                            _controlleremail.text.isNotEmpty) {
                          await signInWithEmailAndPassword();
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: const Text(
                        'Login as Admin',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminRegister()));
                          },
                          child: const Text(
                              'Not Registered ?? Click to Register',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
