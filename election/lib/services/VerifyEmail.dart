import 'dart:async';

import 'package:election/services/IntoLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Auth.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar( ///app bar
        backgroundColor: Colors.cyan,
        leading: IconButton(
          onPressed: () {
            signOut();
          },
          icon: const Icon(Icons.logout_sharp),
        ),
        title: const Text('Verification email sent'),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Center(child: Text('an email has sent to ${user.email} please verify'),),
    );
  }
  Future<void>checkEmailVerified()async{
    user = auth.currentUser!;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      if(!mounted)return;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=> IntroLogin()), (route) => false);
    }
  }
  void refresh() {
    setState(() {});
  }
  Future<void> signOut() async {
    if (!mounted) return;
    await Auth().signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  IntroLogin()),
            (route) => false);
  }
}
