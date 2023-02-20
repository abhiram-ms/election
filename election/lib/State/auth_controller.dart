import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/services/Pickelection.dart';
import 'package:election/services/VerifyEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../services/Auth.dart';
import '../utils/Constants.dart';

class AuthController extends GetxController{

  bool isloading = false;


  //create user metheod using firebase auth
  Future<void> createUserWithEmailAndPassword(Map<String,dynamic> userData,bool admin) async {
    loadingbar();
    try {
      await Auth().createUserwithEmailAndPassword(email:userData['e-mail']!, password:userData['password']!);
      if(Auth().currentuser == null){
        Get.snackbar('Not Authenticated','Failed to do the task' );
      }else if(Auth().currentuser!.emailVerified){
        Get.offAll(()=>  Pickelec(admin:admin));
      }else{
        Get.offAll(()=>const VerifyEmail());
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('firebase auth exception ::: $e');
      }
      Get.snackbar('error occured', '$e');
    }
    loadingbaroff();
  }

  //cloud firestore using firestore
  final CollectionReference admins = FirebaseFirestore.instance.collection('Admins');
  final CollectionReference voters = FirebaseFirestore.instance.collection('voters');

  //add user
  Future<void>addUser(Map<String,dynamic> userData,bool admin)async{
    loadingbar();
    if(admin == true){ // check if adding data to admins or voters
      try{
        await admins.doc(userData['e-mail']).set({
          "Name":userData['Name'],"e-mail":userData['e-mail'],"adhar":userData['adhar'],
          "phone":userData['phone'],"Admin":userData['Admin'],
        });
        Userbox.write('userdata',userData);
      }catch(err){
        if (kDebugMode) {
          print('add user error ::: $err');
        }
      }
    }else{
      try{//add data to voters if admins is false
        await voters.doc(userData['e-mail']).set({
          "Name":userData['Name'],"e-mail":userData['e-mail'],"adhar":userData['adhar'],
          "phone":userData['phone'],"Admin":userData['Admin'],
        });
        Userbox.write('userdata',userData);
      }catch(err){
        if (kDebugMode) {
          print('add user error ::: $err');
        }
      }
    }
    loadingbaroff();
  }

  //sign in with email and password
  Future<void> signInWithEmailAndPassword(String email,String password, bool admin) async {
    loadingbar();
    try {
      loadingbar();
      await Auth().signInwithEmailAndPassword(email: email, password:password);
      if(Userbox.read('userdata') != null){
        Userbox.remove('userdata');
      }
      if(Auth().currentuser == null){
        Get.snackbar('Not Authenticated','Either password or email is wrong' );
      }else{
        if(Auth().currentuser!.emailVerified){
          Get.offAll(()=> Pickelec(admin: admin)); //here we use weather it is admin  or not
        }else{
          Get.offAll(()=>const VerifyEmail());
        }
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('sign in failed:::: $e');
        Get.snackbar('database exception', '$e');
      }
      loadingbaroff();
    }
    loadingbaroff();
  }




  void loadingbar() {
    isloading = true;
    update();
  }

  void loadingbaroff() {
    isloading = false;
    update();
  }

}