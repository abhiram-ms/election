import 'package:election/pages/Admin/AddCandidate.dart';
import 'package:election/pages/Admin/AuthorizeVoter.dart';
import 'package:election/pages/Admin/closeElection.dart';
import 'package:election/services/Electioninfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  late String electionName;
  late String electionAddress;
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

  void refresh() {
    setState(() {});
  }
  @override
  void initState() {
    electionName = widget.electionName;
    electionAddress = widget.electionaddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title:Text('Election : $electionName'),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              signOut();
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  refresh();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
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
                            builder: (context) => AddCandidate(
                                ethClient: widget.ethClient,
                                electionName: widget.electionName, electionAdress:electionAddress,)));
                  },
                  child: Card(borderOnForeground: true,elevation: 4,
                    child: Column(
                      children: [
                        Container(height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image: AssetImage('assets/undraw/electionday.png')))),
                        Container(decoration: BoxDecoration(color: Colors.cyan),width: double.infinity,
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
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthorizeVoter(ethClient:widget.ethClient,electionName:widget.electionName, electionAddress:electionAddress,)));
                  },
                  child: Card(borderOnForeground: true,elevation: 4,
                    child: Column(
                      children: [
                        Container(height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image: AssetImage('assets/undraw/upvote.png')))),
                        Container(decoration: BoxDecoration(color: Colors.cyan),width: double.infinity,
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
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ElectionInfo(ethClient:widget.ethClient,electionName:widget.electionName, electionAddress:electionAddress,)));
                  },
                  child: Card(borderOnForeground: true,elevation: 4,
                    child: Column(
                      children: [
                        Container(height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image: AssetImage('assets/undraw/appreciation.png')))),
                        Container(decoration: BoxDecoration(color: Colors.cyan),width: double.infinity,
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
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CloseElec(ethClient:widget.ethClient,
                                electionName: electionName, electionAdress: electionAddress)));
                  },
                  child: Card(borderOnForeground: true,elevation: 4,
                    child: Column(
                      children: [
                        Container(height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                    image: AssetImage('assets/undraw/noted.png')))),
                        Container(decoration: BoxDecoration(color: Colors.cyan),width: double.infinity,
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
        ));
  }
}
