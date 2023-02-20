import 'package:election/services/Pickelection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../State/Controllers.dart';
import '../pages/Admin/Loginpage.dart';
import '../pages/Voter/VoterLogin.dart';

class IntroLogin extends StatelessWidget {
    const IntroLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DataController dataController = Get.put(DataController());
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
        body: Stack(
          children: [
            Center(
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
                                  Navigator.push(context,MaterialPageRoute(builder:(context)=> Login()));
                                } else {
                                  if(dataController.isAdmin == true){
                                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>const Pickelec(admin: true)),(route) => false);
                                  }else{
                                    Get.snackbar('error', 'cannot do the action');
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
                              style:ElevatedButton.styleFrom(backgroundColor: Colors.white),
                              onPressed: () {
                                if(FirebaseAuth.instance.currentUser?.uid == null){
                                  Navigator.push(context,MaterialPageRoute(builder:(context)=> VoterLogin()));
                                } else {
                                  if(dataController.isAdmin == false){
                                    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>const Pickelec(admin: false)),(route) => false);
                                  }else{
                                    Get.snackbar('error', 'cannot do the action');
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
            GetBuilder<DataController>(builder: (_){
              if (dataController.isloading == true) {
                return Container(
                  color: Colors.white.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(backgroundColor: Colors.redAccent,color: Colors.white,),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
