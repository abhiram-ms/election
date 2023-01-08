import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/Auth.dart';
import '../../services/IntoLogin.dart';
import '../../services/functions.dart';

class CloseElec extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionAdress;
  const CloseElec({Key? key, required this.ethClient, required this.electionName, required this.electionAdress}) : super(key: key);

  @override
  State<CloseElec> createState() => _CloseElecState();
}

class _CloseElecState extends State<CloseElec> {
  void refresh() {
    setState(() {});
  }
  Future<void> signOut() async {
    if (!mounted) return;
    await Auth().signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => IntroLogin()),
            (route) => false);
  }

late String winner = 'No candidate';
late int winnervotes = 0;
late int row = 5;
late int col = 5;
var candidatearray = [] ;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  const BoxDecoration(gradient:
      LinearGradient(colors: [
        Color(0xFF516395),
        Color(0xFF614385 ),
      ])),
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(onPressed: () {
            signOut();
          }, icon: const Icon(Icons.logout_sharp),),
          title: const Text('Election progress'),
          actions: [
            IconButton(onPressed: () {
              refresh();
            }, icon: const Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(margin: const EdgeInsets.only(bottom: 56),
                child: SingleChildScrollView(
                  child: StreamBuilder<List>(stream: getCandidatesNum(
                      widget.ethClient, widget.electionAdress).asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            for (int i = 0; i < snapshot.data![0].toInt(); i++)
                              FutureBuilder<List>(
                                  future: candidateInfo(i, widget.ethClient,
                                      widget.electionAdress),
                                  builder: (context, candidatesnapshot) {
                                    if (candidatesnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      //creating list
                                      List array = List.generate(row, (i) => List.filled(col, null, growable: true), growable: true);
                                      array = candidatesnapshot.data!;
                                      print(array[0][0]);
                                      // logic to decide the winner
                                      if(candidatesnapshot.data![0][1].toInt() > winnervotes){
                                        winnervotes = candidatesnapshot.data![0][1].toInt();
                                        winner = candidatesnapshot.data![0][0];
                                      }else if(candidatesnapshot.data![0][1].toInt() == winnervotes){
                                        winner = candidatesnapshot.data![0][0];
                                      }
                                      print(candidatesnapshot.data);
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
                                          title: Text('Name: ${candidatesnapshot.data![0][0]}',
                                              style: const TextStyle(color: Colors.purple)),
                                          subtitle: Text('Votes: ${candidatesnapshot.data![0][1]}',
                                              style: const TextStyle(color: Colors.purple)),
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
              ),
              const SizedBox(height: 12,),
              Text('The winner of the election is : $winner with votes $winnervotes',style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16,)
            ],
          ),
        ),
      ),
    );
  }
}
