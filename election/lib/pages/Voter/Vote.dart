import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Voter/VoterHome.dart';
import 'package:election/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/Auth.dart';
import '../../services/functions.dart';
import '../../services/IntoLogin.dart';

class VoterVote extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionaddress;
  final List<dynamic> electiondata;
  final  votermap;
  const VoterVote({Key? key, required this.ethClient, required this.electionName,
    required this.electionaddress, this.votermap, required this.electiondata,}) : super(key: key);

  @override
  State<VoterVote> createState() => _VoterVoteState();
}

class _VoterVoteState extends State<VoterVote> {

  final User? user = Auth().currentuser;//fi// rebase auth current user initialization

  //sign out user function
  Future<void> signOut() async {
    if (!mounted) return;
    await Auth().signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  IntroLogin()),
            (route) => false);
  }

  //checking if the voter is already voted
  late bool isAuth = false;
  late bool isVoted = false;

  Future<void>getUserDetail() async {
    var voterdetails = widget.votermap;
    try {
      final DocumentSnapshot voters = await FirebaseFirestore.instance
          .collection('Election')
          .doc(widget.electionName).collection('voterAuth').doc(voterdetails['adharnum'])
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
  }//function to check ends

  TextEditingController privatekeyController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserDetail();
      setState(() { });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(isVoted== true && isAuth == true){
      return Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(onPressed: (){signOut();},icon: const Icon(Icons.logout_sharp),),
            title:const Text('Vote'),
            actions: [
              IconButton(onPressed:(){
                refresh();
               }, icon: const Icon(Icons.refresh))
            ],
          ),
          body: const Center(child: Text('you have already voted sir',style: TextStyle(color: Colors.white),),),
        ),
      );
    }else if(isVoted == false&&isAuth == true){
      return Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: Scaffold(
          appBar:AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(onPressed: (){signOut();},icon: const Icon(Icons.logout_sharp),),
            title:const Text('Vote'),
            actions: [
              IconButton(onPressed:(){
                refresh();
               }, icon: const Icon(Icons.refresh))
            ],
          ),
          body: Container(margin:const EdgeInsets.only(bottom: 56,top: 24),alignment: Alignment.topCenter,
            child:SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: SelectableText("$voter_private_key && $voter_key2 && $voter_key3")
                  ),
                  const SizedBox(height: 24,),
                  Container(padding: const EdgeInsets.all(16),
                    child: TextField(
                        controller: privatekeyController,
                        decoration:
                        const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: 'Private key for voting',border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8))))),
                  ),
                  const SizedBox(height: 24,),
                  SingleChildScrollView(
                    child: StreamBuilder<List>(stream:getCandidatesNum(widget.ethClient,widget.electionaddress).asStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return Column(
                            children: [
                              for (int i = 0; i < snapshot.data![0].toInt(); i++)
                                FutureBuilder<List>(
                                    future: candidateInfo(i, widget.ethClient,widget.electionaddress),
                                    builder: (context, candidatesnapshot) {
                                      if (candidatesnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Container(
                                          padding: const EdgeInsets.all(12),
                                          margin: const EdgeInsets.all(12),
                                          decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(color: Color(0xFF7F5A83),
                                                  offset: Offset(-11.9, -11.9),
                                                  blurRadius: 39,
                                                  spreadRadius: 0.0,
                                                ),
                                                BoxShadow(color: Color(0xFF7F5A83),
                                                  offset: Offset(11.9, 11.9),
                                                  blurRadius: 39,
                                                  spreadRadius: 0.0,
                                                ),
                                              ],
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                              gradient: LinearGradient(colors: [
                                                Color(0xFF74F2CE),
                                                Color(0xFF7CFFCB),
                                              ])),
                                          child: ListTile(
                                            tileColor: Colors.transparent,
                                            title: Text('${candidatesnapshot.data![0][0]}',
                                              style: const TextStyle(color: Colors.purple,fontSize: 16),),
                                            subtitle: const Text('party : mentioned above',
                                              style: TextStyle(color: Colors.purple),),
                                            leading: ConstrainedBox(
                                              constraints: const BoxConstraints(
                                                minHeight: 90,
                                                minWidth: 90,
                                                maxHeight: 100,
                                                maxWidth: 100,
                                              ),
                                              child:const Image(image: AssetImage('assets/undraw/electionday.png')),
                                            ),
                                            trailing: ElevatedButton(
                                                style: ElevatedButton.styleFrom(primary: Colors.white),
                                              onPressed: ()async {
                                                try{
                                                  await votebigFunction(i);
                                                  showSnackBar(succesdetailsnackSnack);
                                                }catch(e){
                                                  if (kDebugMode) {
                                                    print(e);
                                                  }
                                                  showSnackBar(errordetailsnackSnack);
                                                  gotoDashboard();
                                                }
                                              }, child: const Text('Vote',style: TextStyle(color: Colors.purple),)),
                                          ),
                                        );
                                      }
                                    })
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(onPressed: (){signOut();},icon: const Icon(Icons.logout_sharp),),
            title:const Text('Vote'),
            actions: [
              IconButton(onPressed:(){
                refresh();
               }, icon: const Icon(Icons.refresh))
            ],
          ),
          body: const Center(child: Text('you are not authorized please authorize first',style: TextStyle(color: Colors.white),),),
        ),
      );
    }
  }

  //snackbar
  SnackBar errordetailsnackSnack = const SnackBar(content: Text(' already voted or please check your internet connection'));
  SnackBar succesdetailsnackSnack = const SnackBar(content: Text('successfull'));
  SnackBar voterSnack = const SnackBar(content: Text('you are a voter logout from voter account'));
  SnackBar adminSnack = const SnackBar(content: Text('you are an admin logout from Admin account'));
  // SnackBar errorSnack = const SnackBar(content: Text('Fill all the details'));
  // SnackBar datanullSnack = const SnackBar(content: Text('No users registerd yet'));
  //function to show snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void refresh() {
    setState(() {});
  }

  Future<void> registerAuth() async {
    var voterdetails = widget.votermap;
    try {
      await FirebaseFirestore.instance.collection('Election').doc(widget.electionName).collection('voterAuth').doc(voterdetails['adharnum']).update({'isVoted':true});
      print('updated data aaaaaaaaaaaaaaa');
    } catch (e) {
      if (kDebugMode) {
        print('failed to register on firebase $e');
      }
    }
  }
  void gotoDashboard(){
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>VoterHome(ethClient: widget.ethClient,
        electionName: widget.electionName, electionaddress: widget.electionaddress, electiondata: [],)), (route) => false);
  }
   votebigFunction(int i)async{
    await vote(i,widget.ethClient,privatekeyController.text,widget.electionaddress);
    await registerAuth();
    gotoDashboard();
  }

}
