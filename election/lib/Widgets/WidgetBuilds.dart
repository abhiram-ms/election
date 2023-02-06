import 'package:flutter/material.dart';


class SuperWidgets{

  Widget authorisedAlready(BuildContext context)=>Container(
    decoration:  const BoxDecoration(gradient:
    LinearGradient(colors: [
      Color(0xFF516395),
      Color(0xFF614385 ),
    ])),
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: const Center(child: Text('You Are not authorised!',style: TextStyle(color: Colors.white),),),
    ),
  );
}