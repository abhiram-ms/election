import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Admin/AdminHome.dart';
import 'package:election/services/Pickelection.dart';
import 'package:election/services/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Auth.dart';
import '../pages/Admin/Loginpage.dart';
import '../pages/Voter/VoterHome.dart';
import '../pages/Voter/VoterLogin.dart';

class IntroLogin extends StatefulWidget {
   IntroLogin({Key? key}) : super(key: key);

  @override
  State<IntroLogin> createState() => _IntroLoginState();
}

class _IntroLoginState extends State<IntroLogin> with SingleTickerProviderStateMixin{
  //ANIMATION
  late AnimationController _controller;
  late Animation<Offset> _animation;

  final User? currentuser = Auth().currentuser;//firebase auth current user initialization
   bool isAdmin = false;//if admin this is true

  Future<void>getUserDetail() async {    //CHECKING IF IT IS ADMIIN OR NOT
    try {
      if (kDebugMode) {
        print("is admin is :::::${isAdmin}");
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
      print(" status of isadmin is::: ${isAdmin}");
      showSnackBar(succesdetailsnackSnack);
    } catch (e) {
      if (kDebugMode) {
        print('get check user ::::: $e');
        showSnackBar(errordetailsnackSnack);
      }
    }
  }//function to check ends

  @override
  void initState() {
    if(FirebaseAuth.instance.currentUser?.uid != null){
      getUserDetail();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  const BoxDecoration(gradient:
      LinearGradient(colors: [
        Color(0xFF516395),
        Color(0xFF614385 ),
      ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Center(
              child: Text(
            'Election',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Color(0xFF7F5A83),
                              offset: Offset(-4.9, -4.9),
                              blurRadius: 20,
                              spreadRadius: 0.0,
                            ),
                            BoxShadow(color: Color(0xFF7F5A83),
                              offset: Offset(4.9, 4.9),
                              blurRadius: 20,
                              spreadRadius: 0.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10)),),
                      width: 300,
                      height: 56,
                      margin: const EdgeInsets.only(top: 0),
                      child: ElevatedButton(
                        style:ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          onPressed: () {
                            if(FirebaseAuth.instance.currentUser?.uid == null){
                              Navigator.push(context,MaterialPageRoute(builder:(context)=>Login()));
                            } else {
                              if(isAdmin == true){
                                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>Pickelec(admin: true)),(route) => false);
                              }else{
                                showSnackBar(voterSnack);
                              }
                            }
                          },
                          child: const Text('Admin Login',style: TextStyle(color: Colors.purple),)),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Color(0xFF7F5A83),
                              offset: Offset(-4.9, -4.9),
                              blurRadius: 25,
                              spreadRadius: 0.0,
                            ),
                            BoxShadow(color: Color(0xFF7F5A83),
                              offset: Offset(4.9, 4.9),
                              blurRadius: 25,
                              spreadRadius: 0.0,
                            ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10)),),
                      height: 56,
                      width: 300,
                      child: ElevatedButton(
                          style:ElevatedButton.styleFrom(primary: Colors.white),
                          onPressed: () {
                            if(FirebaseAuth.instance.currentUser?.uid == null){
                              Navigator.push(context,MaterialPageRoute(builder:(context)=>VoterLogin()));
                            } else {
                              if(isAdmin == false){
                                Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>Pickelec(admin: false)),(route) => false);
                              }else{
                                showSnackBar(adminSnack);
                              }
                            }
                          },
                          child: const Text('Voter Login',style: TextStyle(color: Colors.purple))),
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

  //snackbar
  SnackBar errordetailsnackSnack = const SnackBar(content: Text('You are not logged in if you are please check your internet connection'));
  SnackBar succesdetailsnackSnack = const SnackBar(content: Text('successfull'));
  SnackBar voterSnack = const SnackBar(content: Text('you are a voter logout from voter account'));
  SnackBar adminSnack = const SnackBar(content: Text('you are an admin logout from Admin account'));
  // SnackBar errorSnack = const SnackBar(content: Text('Fill all the details'));
  // SnackBar datanullSnack = const SnackBar(content: Text('No users registerd yet'));
  //function to show snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
