import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VoterCardController extends GetxController{
  String electionName;
  Map<String,dynamic>? votermap;


  VoterCardController(this.electionName,this.votermap);

  // Future<void>signOut()async{
  //   await Auth().signOut();
  //   if(!mounted)return;
  //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>IntroLogin()), (route) => false);
  // }

  //checking if the voter is already voted
  late bool isAuth = false;
  late bool isVoted = false;

  Future<void>getUserDetail(String electionName, Map<String,dynamic>? votermap ) async {
    var voterdetails = votermap;
    try {
      final DocumentSnapshot voters = await FirebaseFirestore.instance
          .collection('Election')
          .doc(electionName).collection('voterAuth').doc(voterdetails!['adharnum'])
          .get();
      if (voters.data() != null) {
        isAuth = voters.get('isAuth');
        isVoted = voters.get('isVoted');
      }else{
        isAuth = false;
        isVoted= false;
        print('cannot find details');
      }
    } catch (e) {
      if (kDebugMode) {
        print('get check user ::::: $e');
      }
    }
    update();
  }//function to check ends

@override
  void onInit() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    getUserDetail(electionName, votermap);
    update();
  });
    super.onInit();
  }


}