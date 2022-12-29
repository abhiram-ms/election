import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/services/IntoLogin.dart';
import 'package:election/pages/Voter/Vote.dart';
import 'package:election/pages/Voter/VoteRegister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/Auth.dart';
import '../../utils/Constants.dart';
import '../../services/Electioninfo.dart';
import '../../services/VerifyEmail.dart';

class VoterHome extends StatefulWidget {
  //getting required parameters to pass on to vote and authorize
  final Web3Client ethClient;
  final String electionName;
  final String electionaddress;
  const VoterHome({Key? key, required this.ethClient, required this.electionName, required this.electionaddress}) : super(key: key);

  @override
  State<VoterHome> createState() => _VoterHomeState();
}

class _VoterHomeState extends State<VoterHome> {
  //creating clients
  late Client? httpClient;//http client
  late Web3Client? ethclient;// eth client
//sign out user
  final User? user = Auth().currentuser;
  Future<void>signOut()async{
    await Auth().signOut();
    if(!mounted)return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>IntroLogin()), (route) => false);
  }
 // voters info
   var email;
   var adhar;
   var name;
   var phone;

  //checking if voter authorized or voted   // dont have to do this because we does this on the respected pages
  late bool isAuth = false;//if  he is authorized
  late  bool isVoted = false;//if he is voted
  Future<void>getUserDetail() async {
    try {
      final DocumentSnapshot voters = await FirebaseFirestore.instance
          .collection('voters')
          .doc(user?.email)
          .get();
      if (voters.data() != null) {
        email = voters.get('email');
        name = voters.get('name');
        phone = voters.get('phone');
        adhar = voters.get('adharnum');
        print('adhar is $adhar');

      }else{
        print('cannot find details');
      }
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
    httpClient = Client();
    ethclient = Web3Client(infura_url, httpClient!);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getUserDetail();
      setState(() { });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> voterdata = {'name':name,'adharnum':adhar.toString(),'email':email,};
    if(user!.emailVerified){
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () { signOut(); }, icon: const Icon(Icons.logout),),
            actions: [IconButton(onPressed:(){setState(() {});}, icon: const Icon(Icons.refresh))],
            title: const Text('Voter DASHBOARD'),backgroundColor: Colors.cyan,),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VoteRegister(electionName:widget.electionName,
                                  ethClient: widget.ethClient, electionaddress:widget.electionaddress,adhar:adhar,)));
                    },
                    child: Card(borderOnForeground: true,elevation: 4,
                      child: Column(
                        children: [
                          Container(height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/undraw/electionday.png')))),
                          Container(decoration: const BoxDecoration(color: Colors.cyan),width: double.infinity,
                            child: const Center(
                              child: Text('Register to Vote',style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize:16,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VoterVote(ethClient:ethclient!,electionName:widget.electionName,
                                  electionaddress:widget.electionaddress ,votermap:voterdata,)));
                    },
                    child: Card(borderOnForeground: true,elevation: 4,
                      child: Column(
                        children: [
                          Container(height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/undraw/upvote.png')))),
                          Container(decoration: const BoxDecoration(color: Colors.cyan),width: double.infinity,
                            child: const Center(
                              child: Text('Vote',style: TextStyle(fontWeight: FontWeight.bold,fontSize:16,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ElectionInfo(ethClient:ethclient!,electionName:widget.electionName,
                                electionAddress:widget.electionaddress,)));
                    },
                    child: Card(borderOnForeground: true,elevation: 4,
                      child: Column(
                        children: [
                          Container(height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/undraw/electionday.png')))),
                          Container(decoration: const BoxDecoration(color: Colors.cyan),width: double.infinity,
                            child: const Center(
                              child: Text('Election details',style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize:16,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
      );
    }else{
      return Scaffold(
        appBar:AppBar( ///app bar
          backgroundColor: Colors.cyan,
          leading: IconButton(
            onPressed: () {
              signOut();
            },
            icon: const Icon(Icons.logout_sharp),
          ),
          title: const Text('Verify Voter email'),
          actions: [
            IconButton(
                onPressed: () {
                  refresh();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Container(margin: const EdgeInsets.only(top: 56),
          child: Center(
            child: Column(
              children: [
                Text('Your Email ${user?.email} is not verified'),
                const SizedBox(height: 24,),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const VerifyEmail()),
                              (route) => false);
                    },
                    child: const Text('Verify Email'))
              ],
            ),
          ),
        ),
      );
    }
  }
  //function to refresh using setstate
  void refresh() {
    setState(() {});
  }
  //snackbar
  SnackBar errordetailsnackSnack = const SnackBar(content: Text('You are not logged in if you are please check your internet connection'));
  SnackBar succesdetailsnackSnack = const SnackBar(content: Text('successfull'));
  SnackBar votedSnack = const SnackBar(content: Text('You have already voted'));
  SnackBar RegisterSnack = const SnackBar(content: Text('You have already registered'));
  // SnackBar errorSnack = const SnackBar(content: Text('Fill all the details'));
  // SnackBar datanullSnack = const SnackBar(content: Text('No users registerd yet'));
  //function to show snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
