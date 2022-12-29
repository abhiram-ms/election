
import 'package:election/pages/Voter/VoterHome.dart';
import 'package:election/services/Pickelection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/Auth.dart';
import 'VoterRegister.dart';

class VoterLogin extends StatefulWidget {
  const VoterLogin({Key? key}) : super(key: key);

  @override
  State<VoterLogin> createState() => _VoterLoginState();
}

class _VoterLoginState extends State<VoterLogin> {

  String? errormessage = '';
  bool _istrue = true;
  bool _isloading = false;

  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();


  Future<void>signInWithEmailAndPassword()async{
    setState(() {_isloading = true;});
    try{//try
      //await and call metheod
      await Auth().signInwithEmailAndPassword(email: _controlleremail.text, password:_controllerpassword.text);
      if(!mounted)return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  Pickelec(admin: false)),(route) => false);

    } on FirebaseAuthException catch(e){//catch
      setState(() {
        errormessage = e.message;//stores error message to errormessage
      });
    }
    if(mounted){setState(() {_isloading = false;});}
  }



  @override
  Widget build(BuildContext context) {
    if(_isloading){
      return const Scaffold(
        backgroundColor: Colors.cyan,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else{
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Login Voter",
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
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child:TextField(
                          controller: _controlleremail,
                          decoration: const InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8))))),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child:TextField(
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
                        if(_controllerpassword.text.isNotEmpty && _controlleremail.text.isNotEmpty){
                          await signInWithEmailAndPassword();
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: const Text(
                        'Login as Voter',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VoterRegister()));
                          },
                          child: const Text('Not Registered ?? Click to Register',
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
