
import 'package:election/pages/Admin/AdminHome.dart';
import 'package:election/pages/Admin/DashBoard.dart';
import 'package:election/pages/Voter/VoterHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import '../utils/Constants.dart';
import 'Auth.dart';
import 'IntoLogin.dart';
import 'functions.dart';

class Pickelec extends StatefulWidget {
  final bool admin;
  const Pickelec({Key? key, required this.admin}) : super(key: key);

  @override
  State<Pickelec> createState() => _PickelecState();
}

class _PickelecState extends State<Pickelec> {

  late Client? httpClient;
  late Web3Client? ethclient;
  final User? user = Auth().currentuser;
  Future<void>signOut()async{
    await Auth().signOut();
    if(!mounted)return;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>IntroLogin()), (route) => false);
  }

  @override
  void initState() {
    httpClient = Client();
    ethclient = Web3Client(infura_url, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.admin == true){
      return  Scaffold(
        appBar:  AppBar(
          leading: IconButton(onPressed: () { signOut(); }, icon: const Icon(Icons.logout),),
          actions: [
            IconButton(onPressed:(){setState(() {});}, icon: const Icon(Icons.refresh)),
            IconButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context)=>AdminHome()));
            }, icon: const Icon(Icons.how_to_vote))
          ],
          title: const Text('Admin Pick Election'),backgroundColor: Colors.cyan,),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(margin:const EdgeInsets.only(bottom: 56),
                  child: SingleChildScrollView(
                    child: StreamBuilder<List>(stream:getElectionCounts(ethclient!,contractAdressConst).asStream(),
                      builder: (context, snapshot) {
                        try{
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }else if(snapshot.data![0].toInt()==0){
                            return const Center(
                              child: Text("no elections for now "),
                            );
                          } else {
                            return Column(
                              children: [
                                for (int i = 0; i < snapshot.data![0].toInt(); i++)
                                  FutureBuilder<List>(
                                      future: getDeployedElection(i,ethclient!,contractAdressConst),
                                      builder: (context, electionsnapshot) {
                                        if (electionsnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          if (kDebugMode) {
                                            print('${electionsnapshot.data}');
                                          }
                                          return  ListTile(
                                            onTap: (){
                                              Navigator.pushAndRemoveUntil(context,
                                                  MaterialPageRoute(builder:(context)=>DashBoard(ethClient:ethclient!, electionName:electionsnapshot.data![0][0],
                                                    electionaddress:electionsnapshot.data![0][1].toString(),)), (route) => false);
                                            },
                                            title: Text('Name:${electionsnapshot.data![0][0]} '),
                                            subtitle: Text('Votes:${electionsnapshot.data![0][1]} '),
                                          );
                                        }
                                      })
                              ],
                            );
                          }
                        }catch(e) {
                          return  Center(
                            child: Text("Cannot acess this page for now ${e}"),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

    }else{
      return  Scaffold(
        appBar:  AppBar(
          leading: IconButton(onPressed: () { signOut(); }, icon: const Icon(Icons.logout),),
          actions: [IconButton(onPressed:(){setState(() {});}, icon: const Icon(Icons.refresh))],
          title: const Text('Voter Pick Election'),backgroundColor: Colors.cyan,),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(margin:const EdgeInsets.only(bottom: 56),
                  child: SingleChildScrollView(
                    child: StreamBuilder<List>(stream:getElectionCounts(ethclient!,contractAdressConst).asStream(),
                      builder: (context, snapshot) {
                      try{
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }else if(snapshot.data![0].toInt()==0){
                          return const Center(
                            child: Text("no elections for now "),
                          );
                        } else {
                          return Column(
                            children: [
                              for (int i = 0; i < snapshot.data![0].toInt(); i++)
                                FutureBuilder<List>(
                                    future: getDeployedElection(i,ethclient!,contractAdressConst),
                                    builder: (context, electionsnapshot) {
                                      if (electionsnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        if (kDebugMode) {
                                          print('${electionsnapshot.data}');
                                        }
                                        return ListTile(
                                          onTap: (){
                                            Navigator.pushAndRemoveUntil(context,
                                                MaterialPageRoute(builder:(context)=>VoterHome(ethClient:ethclient!, electionName:electionsnapshot.data![0][0],
                                                    electionaddress:electionsnapshot.data![0][1].toString())), (route) => false);
                                          },
                                          title: Text('Name: ${electionsnapshot.data![0][0]}'),
                                          subtitle: Text('Votes: ${electionsnapshot.data![0][1]}'),
                                        );
                                      }
                                    })
                            ],
                          );
                        }
                      }catch(e) {
                        return  Center(
                          child: Text("Cannot acess this page for now ${e}"),
                        );
                      }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
  //
  // title: Text('Name: ${electionsnapshot.data![0][0]}'),
  // subtitle: Text('Votes: ${electionsnapshot.data![0][1]}'),
}
