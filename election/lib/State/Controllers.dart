import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/Auth.dart';


class DataController extends GetxController {

  late bool isAdmin;
  late User? currentuser;
  bool isloading = false;

  @override
  void onInit() {
     currentuser = Auth().currentuser;//firebase auth current user initialization
     isAdmin = false;
     if (kDebugMode) {
       print('this is isadmin $isAdmin');
     }


    //on intro login initialization
    if(FirebaseAuth.instance.currentUser?.uid  != null){

      if(elecbox.read('userdata') != null ){
        isAdmin = elecbox.read('userdata')['Admin'];

        if (kDebugMode) {
          print('this is isadmin $isAdmin');
        }
        update();

      }else{
        getUserDetail();
      }
    }else{
      if (kDebugMode) {
        print('uid is null');
      }
    }
    super.onInit();
  }

  //Intro Login Controller  ----------------------------------------------------------------------------------->

  Future<void>getUserDetail() async {//CHECKING IF IT IS ADMIIN OR NOT
    loadingbar();
    try {
      if (kDebugMode) {
        print("is admin is :::::$isAdmin");
      }
      if (kDebugMode) {
        print("current  user email is:::: ${currentuser?.email}");
      }
      final DocumentSnapshot user = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(currentuser?.email)
          .get();
      if (user.data() != null) {
        isAdmin = true;
      }else{
        isAdmin = false;
      }
      if (kDebugMode) {
        print(" status of is admin is::: $isAdmin");
      }
     // Get.snackbar('success', 'success');
    } catch (e) {
      if (kDebugMode) {
        print('get check user ::::: $e');
        //Get.snackbar('error occurred', '$e');
      }
    }
    loadingbaroff();
    update();
  }//function to check ends

//------------------------------------------------------------------------------------------------------------->

  void loadingbar() {
    isloading = true;
    update();
  }

  void loadingbaroff() {
    isloading = false;
    update();
  }
//------------------------------------------------------------------------------------------------------------->




}