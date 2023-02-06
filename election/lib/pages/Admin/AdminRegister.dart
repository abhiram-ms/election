import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Admin/AdminHome.dart';
import 'package:election/services/VerifyEmail.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:election/services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../services/snackbar.dart';
import '../../utils/Constants.dart';

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

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
      box.write('name',Name);
    }catch(err){
      if (kDebugMode) {
        print(err);
      }
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
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              "Register as Admin",
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
          body: Container(
            margin: const EdgeInsets.all(16),
            color: Colors.transparent,
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      UserTextInput(controller: _controllerName,hinttext: 'Name as in adhar *'),
                      UserTextInput(controller: _controlleremail,hinttext: 'Email of user *'),
                      UserTextInput(controller: _controllerphone,hinttext: 'Phone number as in adhar *'),
                      UserTextInput(controller: _controllerpassword,hinttext: 'Password (8- characters) *'),
                      UserTextInput(controller: _controllerrepassword,hinttext: ' confirm your password*'),
                      ElevatedButton(
                        onPressed: () async {
                          final FormState? form = _formkey.currentState;
                          if(form != null){
                            if(form.validate()){
                              await addAndCreateUser();
                            }else{
                              snackbarshow().showSnackBar(snackbarshow().errorAdharSnack, context);
                            }
                          }else{
                            snackbarshow().showSnackBar(snackbarshow().errorAdharSnack, context);
                          }
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                        child: const Text(
                          'Register as Admin',
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


class UserTextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? hinttext;
  final bool? obscuretext;
  const UserTextInput({
    Key? key, required this.controller, this.hinttext, this.obscuretext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom:16),
      padding: const EdgeInsets.all(8),
      child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: obscuretext!=null?true:false,
          controller: controller,
          validator: (value){
            if(value == null||value.isEmpty){
              return 'please enter the details';
            }
            return null;
          },
          decoration:  InputDecoration(
            hintStyle: const TextStyle(color:Colors.white),
            hintText: hinttext,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(
                color: Colors.purpleAccent,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
