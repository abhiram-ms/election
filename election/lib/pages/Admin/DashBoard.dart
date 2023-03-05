import 'package:election/pages/Admin/AddCandidate.dart';
import 'package:election/pages/Admin/AuthorizeVoter.dart';
import 'package:election/pages/Admin/closeElection.dart';
import 'package:election/services/Electioninfo.dart';
import 'package:election/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/Auth.dart';
import '../../services/IntoLogin.dart';

class DashBoard extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionaddress;
  const DashBoard(
      {Key? key, required this.ethClient, required this.electionName, required this.electionaddress})
      : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  //variables
  // late String electionName;
  // late String electionAddress;
//firebase auth instance initialization
  final User? user = Auth().currentuser; //fi// rebase auth current user initialization

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

  @override
  void initState() {
    Map<String,dynamic> electionData = {"electionName" : widget.electionName,
    "electionAddress" : widget.electionaddress,};
    elecdata.write('elecData',electionData);
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title:Text('Election : ${elecdata.read('elecData')['electionName']}'),
            leading: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                signOut();
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                  },
                  icon: const Icon(Icons.refresh))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.only(left: 24,right: 24,bottom: 8,top: 8),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddCandidate(
                                  ethClient: widget.ethClient,
                                  electionName: widget.electionName, electionAdress:widget.electionaddress,)));
                    },
                    child: Card(borderOnForeground: true,elevation: 4,
                      child: Column(
                        children: [
                          Container(height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/undraw/electionday.png')))),
                          Container(decoration: const BoxDecoration(color: Colors.purple),width: double.infinity,
                            child: const Center(
                              child: Text('Add Candidate',style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize:16,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Color(0xFF8693AB),
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
                  ),
                  padding: const EdgeInsets.only(left: 24,right: 24,bottom: 8,top: 4),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AuthorizeVoter(ethClient:widget.ethClient,electionName:widget.electionName, electionAddress:widget.electionaddress,)));
                    },
                    child: Card(borderOnForeground: true,elevation: 4,
                      child: Column(
                        children: [
                          Container(height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/undraw/upvote.png')))),
                          Container(decoration: const BoxDecoration(color: Colors.purple),width: double.infinity,
                            child: const Center(
                              child: Text('Authorize Voter',style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize:16,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Color(0xFF8693AB),
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
                  ),
                  padding: const EdgeInsets.only(left: 24,right: 24,bottom: 8,top: 4),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ElectionInfo(ethClient:widget.ethClient,electionName:widget.electionName, electionAddress:widget.electionaddress,)));
                    },
                    child: Card(borderOnForeground: true,elevation: 4,
                      child: Column(
                        children: [
                          Container(height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/undraw/appreciation.png')))),
                          Container(decoration: const BoxDecoration(color: Colors.purple),width: double.infinity,
                            child: const Center(
                              child: Text('Election Info',style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize:16,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  padding: const EdgeInsets.only(right: 24,left: 24,bottom: 8,top: 4),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CloseElec(ethClient:widget.ethClient,
                                  electionName: widget.electionName, electionAdress: widget.electionaddress)));
                    },
                    child: Card(borderOnForeground: true,elevation: 4,
                      child: Column(
                        children: [
                          Container(height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: const DecorationImage(
                                      image: AssetImage('assets/undraw/noted.png')))),
                          Container(decoration: const BoxDecoration(color: Colors.purple),width: double.infinity,
                            child: const Center(
                              child: Text('End election Get Results',style: TextStyle(
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
          )),
    );
  }
}
