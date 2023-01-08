import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Voter/VoterHome.dart';
import 'package:election/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/Auth.dart';
import '../../services/IntoLogin.dart';

class VoteRegister extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionaddress;
  final List<dynamic>electiondata;
  final String adhar;
  const VoteRegister({Key? key, required this.ethClient, required this.electionName,
    required this.electionaddress, required this.adhar, required this.electiondata,}) : super(key: key);

  @override
  State<VoteRegister> createState() => _VoteRegisterState();
}

class _VoteRegisterState extends State<VoteRegister> {
  final user = Auth().currentuser;
  //sign out user
  Future<void>signOut()async{
    await Auth().signOut();
    if(!mounted)return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>IntroLogin()), (route) => false);
  }

  //text editing controllers
  //TextEditingController voterAdhar = TextEditingController();
  TextEditingController voterAdress = TextEditingController();
  TextEditingController voterName = TextEditingController();
  TextEditingController voterAge = TextEditingController();

  late bool isAuth = false;
  late bool isVoted = false;

  Future<void>getUserDetail() async {
    // var voterdetails = widget.votermap;
    try {
      final DocumentSnapshot voters = await FirebaseFirestore.instance
          .collection('Election')
          .doc(widget.electionName).collection('voterAuth').doc(widget.adhar)
          .get();
      if (voters.data() != null) {
        isAuth = voters.get('isAuth');
        isVoted = voters.get('isVoted');
        print('is auth is :$isAuth && is voted is : $isVoted');
      }else{
        isAuth = false;
        isVoted = false;
        print('cannot find details');
      }
    } catch (e) {
      if (kDebugMode) {
        print('get check user ::::: $e');
      }
    }
  }//function to check ends

  @override initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserDetail();
      setState(() { });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isAuth == true){
      return Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () { signOut(); }, icon: const Icon(Icons.logout),),
            actions: [IconButton(onPressed:(){setState(() {});}, icon: const Icon(Icons.refresh))],
            title: const Text('Voter DASHBOARD'),backgroundColor: Colors.transparent,),
          body: const Center(child: Text('you have already authorized',style: TextStyle(color: Colors.white),),),
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
            leading: IconButton(onPressed: () { signOut(); }, icon: const Icon(Icons.logout),),
            actions: [IconButton(onPressed:(){setState(() {});}, icon: const Icon(Icons.refresh))],
            title: const Text('Voter DASHBOARD'),backgroundColor: Colors.transparent,),
          body: SingleChildScrollView(
            child:Container(padding:const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 24,),
                  SelectableText('$voter_adress&&$voter_adress2&&$voter_adress3'),
                  const SizedBox(height: 12,),
                  Center(
                    child: TextField(
                        controller: voterName,
                        decoration:
                        const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Name as in Adhar',border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8))))
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Center(
                    child: TextField(
                        controller: voterAge,
                        decoration:
                        const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Age as in adhar',border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8))))
                    ),
                  ),
                  const SizedBox(height: 12,),
                  const SizedBox(height: 24,),
                  Center(
                    child: TextField(
                      controller: voterAdress,
                      decoration:
                      const InputDecoration(
                          hintStyle: TextStyle(color: Colors.white),
                          hintText: 'Metamask Adress',border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                    ),
                  ),
                  const SizedBox(height: 24,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () async {
                        if(voterAdress.text.isNotEmpty){
                          if(voterName.text.isNotEmpty&&voterAge.text.isNotEmpty) {
                            try{
                              await registerVoterAuthorize(widget.adhar,voterAdress.text,voterName.text,voterAge.text,user?.email);
                              showSnackBar(succesRegisterSnack);
                              gotoDashboard();
                            }catch(e){
                              if (kDebugMode) {
                                print('this is prblmmmmmm   $e');
                              }
                              showSnackBar(errorRegisterSnack);
                            }
                          }else{showSnackBar(detailserrorSnack);}
                        }else{showSnackBar(detailserrorSnack);}
                      },
                      child: const Text('Register',style: TextStyle(color: Colors.purple),))
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> registerVoterAuthorize(String adharnum,String voterAdress,String voterName,String voterAge,String? email) async {
    try {
      final CollectionReference VoterAuth = await FirebaseFirestore.instance.collection('Election')
          .doc(widget.electionName).collection('voterAuth');
      await VoterAuth.doc(adharnum).set({
        "adharnum":adharnum,"isVoted":false,"isAuth":false,"voterAddress":voterAdress,"voterName":voterName,"voterAge":voterAge,"email":email});
      print('user added successfullyyyyyyy');
      showSnackBar(succesRegisterSnack);
    } catch (e) {
      if (kDebugMode) {
        print('Registration failed ::::: $e');
      }
      showSnackBar(errorRegisterSnack);
    }
  }
  SnackBar errorRegisterSnack = const SnackBar(content:Text('Register failed make sure details are right'));
  SnackBar succesRegisterSnack = const SnackBar(content:Text('Registration successfull'));
  SnackBar detailserrorSnack = const SnackBar(content:Text('Fill all the details'));

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar){
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void gotoDashboard(){
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>
        VoterHome(ethClient:widget.ethClient, electionName:widget.electionName, electionaddress:widget.electionaddress,
          electiondata:widget.electiondata,)), (route) => false);
  }

}
