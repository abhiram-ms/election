import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Admin/AdminHome.dart';
import 'package:election/services/VerifyEmail.dart';
import 'package:flutter/material.dart';
import 'package:election/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRegister extends StatefulWidget {
  const AdminRegister({Key? key}) : super(key: key);

  @override
  State<AdminRegister> createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {

  String? errormessage = '';
  String? errorAddUser = '';

  late String Name;
  late String Email;
  late String Phone;
  late String Password;
  late String Admin_Key;

  final bool _istrue = true;
  bool _isloading = false;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerphone = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();
  final TextEditingController _controllerrepassword = TextEditingController();
  final TextEditingController _controllerAdminKey = TextEditingController();

//create user metheod using firebase auth
  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserwithEmailAndPassword(email: _controlleremail.text, password: _controllerpassword.text);
      if(mounted){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  VerifyEmail()),(route) => false);
      }else{return;}
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message;
      });
    }
  }

  //cloud firestore using firestore
  final CollectionReference Admins = FirebaseFirestore.instance.collection('Admins');

  Future<void>addUser()async{
    Name = _controllerName.text;
    Email=_controlleremail.text;
    Password=_controllerpassword.text;
    Phone=_controllerphone.text;
    try{
      await Admins.doc(Email).set({
        "Name":Name,"email":Email,"password":Password,"phone":Phone,"Admin":_istrue});
      print('user added successfullyyyyyyy');
    }catch(err){

    }
  }

  Future<void>addAndCreateUser()async{
    setState(() { _isloading = true; });
    await createUserWithEmailAndPassword();
    await addUser();
    if(mounted){
      setState(() { _isloading = false; });
    }
  }

  Widget _errorMessage() {
    return Text(errormessage == '' ? '' : 'Humm $errormessage');
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
    }else{
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Register as Admin",
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
                          controller: _controllerName,
                          decoration: const InputDecoration(
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
                          controller: _controllerphone,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'phone number as in adhar',
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
                              hintText: 'Re enter password',
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8))))),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_controllerpassword.text.isNotEmpty && _controlleremail.text.isNotEmpty) {
                          if(_controllerName.text.isNotEmpty&&_controllerphone.text.isNotEmpty){
                            if(_controllerpassword.text.length>7&&_controllerpassword.text==_controllerrepassword.text){
                              await addAndCreateUser();
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      child: const Text(
                        'Register as Admin',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    )
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
