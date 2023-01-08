import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Voter/VoterHome.dart';
import 'package:election/services/Pickelection.dart';
import 'package:election/services/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/Auth.dart';

class VoterRegister extends StatefulWidget {
  const VoterRegister({Key? key}) : super(key: key);

  @override
  State<VoterRegister> createState() => _VoterRegisterState();
}

class _VoterRegisterState extends State<VoterRegister> {
  String? errormessage = '';
  final bool _istrue = false;

  late String Name;
  late String Email;
  late String Phone;
  late String Password;
  late String Voter_Key;
  late String adhar;

  bool _isloading = false;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerphone = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();
  final TextEditingController _controllerrepassword = TextEditingController();
  final TextEditingController _controlleradhar = TextEditingController();
 // final TextEditingController _controllerVoterKey = TextEditingController();
//create user metheod
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserwithEmailAndPassword(
          email: _controlleremail.text, password: _controllerpassword.text);
      if(!mounted)return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>Pickelec(admin: false)),(route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
        print('account not created'+"${errormessage}");
      });
    }
  }

  //firestore add user
  //cloud firestore using firestore
  final CollectionReference Voters = FirebaseFirestore.instance.collection('voters');

  Future<void>addUser()async{
    Name      =  _controllerName.text;
    Email     =  _controlleremail.text;
    Password  =  _controllerpassword.text;
    Phone     =  _controllerphone.text;
    adhar     =  _controlleradhar.text.toString();
    try{
      await Voters.doc(Email).set({
        "name":Name,"email":Email,"password":Password,"phone":Phone,"Admin":_istrue,"adharnum":adhar,});
      print("user added successfully");
    }catch(err){
      print("user not added");
    }
  }

  Widget _errorMessage() {
    return Text(errormessage == '' ? '' : 'Humm $errormessage');
  }

  Future<void>addAndCreateUser()async{
    setState(() { _isloading = true; });
    await createUserWithEmailAndPassword();
    await addUser();
    if(mounted){
      setState(() { _isloading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_isloading){
      return Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }else{
      return Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Register Voter",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(16),
            color: Colors.transparent,
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
                        padding: EdgeInsets.all(16),
                        child: TextField(
                            controller: _controllerName,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: 'Name',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                            controller: _controlleremail,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: 'email id',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                            controller: _controlleradhar,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: 'enter your adhar number',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                            controller: _controllerphone,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: 'phone number in your adhar',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                            controller: _controllerpassword,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: 'password',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                            controller: _controllerrepassword,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: 'Re enter password',
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))))),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_controllerpassword.text.isNotEmpty && _controlleremail.text.isNotEmpty) {
                            if(_controllerName.text.isNotEmpty){
                              if(_controllerphone.text.isNotEmpty&&_controllerpassword.text==_controllerrepassword.text){
                                if(_controllerpassword.text.length>7){
                                  await createUserWithEmailAndPassword().then((value) => () async {
                                    await addUser();
                                  });
                                }
                                snackbarshow().showSnackBar(snackbarshow().errorSnack, context);
                              }
                              snackbarshow().showSnackBar(snackbarshow().errorSnack, context);
                            }
                            snackbarshow().showSnackBar(snackbarshow().errorSnack, context);
                          }
                          snackbarshow().showSnackBar(snackbarshow().errorSnack, context);
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        child: const Text(
                          'Register as Voter',
                          style: TextStyle(color: Colors.purple),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
