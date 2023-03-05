// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:election/pages/Admin/AdminHome.dart';
// import 'package:election/pages/Admin/DashBoard.dart';
// import 'package:election/pages/Voter/VoterHome.dart';
// import 'package:election/services/snackbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:web3dart/web3dart.dart';
// import 'package:http/http.dart';
//
// import '../services/Auth.dart';
// import '../services/IntoLogin.dart';
// import '../services/functions.dart';
// import '../utils/Constants.dart';
//
// class Pickelecdupe extends StatefulWidget {
//   final bool admin;
//   const Pickelecdupe({Key? key, required this.admin}) : super(key: key);
//
//   @override
//   State<Pickelecdupe> createState() => _PickelecdupeState();
// }
//
// class _PickelecdupeState extends State<Pickelecdupe> {
//
//   //clients
//   late Client? httpClient;
//   late Web3Client? ethclient;
//
//   //user
//   final User? user = Auth().currentuser;
//
//   Future<void> signOut() async {
//     await Auth().signOut();
//     if (!mounted) return;
//     Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => const IntroLogin()),
//             (route) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.admin == true) {
//       //if he is admin continue
//       return Container(//for the background
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(colors: [
//               Color(0xFF516395),
//               Color(0xFF614385),
//             ])),
//         child: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               onPressed: () {
//                 signOut();
//               },
//               icon: const Icon(Icons.logout),
//             ),
//             actions: [
//               IconButton(
//                   onPressed: () {
//                     setState(() {});
//                   },
//                   icon: const Icon(Icons.refresh)),
//               IconButton(
//                   onPressed: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) =>   AdminHome()));
//                   },
//                   icon: const Icon(Icons.how_to_vote))
//             ],
//             title: const Text('Admin Pick Election'),
//             backgroundColor: Colors.transparent,
//           ),
//           body: SingleChildScrollView(
//             child: Column(        //colum contains all elements
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 56),
//                   child: SingleChildScrollView(
//                     child: StreamBuilder<List>(
//                       stream: getElectionCounts(ethclient!, contractAdressConst).asStream(),
//                       builder: (context, snapshot) {
//                         try {
//                           if (snapshot.connectionState == ConnectionState.waiting) {
//                             return const Center(child: CircularProgressIndicator(),);//returns loading while connecting
//                           } else if (snapshot.data![0].toInt() == 0) {
//                             return const Center(child: Text("no elections for now "),);//if value is zero
//                           } else {   //if there is value
//                             return Column(
//                               children: [
//                                 for (int i = 0;i < snapshot.data![0].toInt(); i++)//this will run loop
//                                   FutureBuilder<List>(
//                                       future: getDeployedElection(i, ethclient!, contractAdressConst),
//                                       builder: (context, electionsnapshot) {
//                                         if (electionsnapshot.connectionState == ConnectionState.waiting) {
//                                           return const Center(child: Text('Fetching election data...'),);
//                                         } else {
//                                           if (kDebugMode) {
//                                             print('${electionsnapshot.data}');
//                                           }
//                                           return Container(
//                                             padding: const EdgeInsets.all(12),
//                                             margin: const EdgeInsets.all(12),
//                                             decoration: const BoxDecoration(
//                                                 boxShadow: [
//                                                   BoxShadow(color: Color(0xFF7F5A83),
//                                                     offset: Offset(-11.9, -11.9),
//                                                     blurRadius: 39,
//                                                     spreadRadius: 0.0,
//                                                   ),
//                                                   BoxShadow(color: Color(0xFF7F5A83),
//                                                     offset: Offset(11.9, 11.9),
//                                                     blurRadius: 39,
//                                                     spreadRadius: 0.0,
//                                                   ),
//                                                 ],
//                                                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                                                 gradient: LinearGradient(colors: [
//                                                   Color(0xFF74F2CE),
//                                                   Color(0xFF7CFFCB),
//                                                 ])),
//                                             child: ListTile(
//                                               tileColor: Colors.transparent,
//                                               onTap: () {
//                                                 Navigator.pushAndRemoveUntil(context,MaterialPageRoute(
//                                                     builder: (context) => DashBoard(ethClient:ethclient!,
//                                                       electionName:electionsnapshot.data![0][0],
//                                                       electionaddress: electionsnapshot.data![0][1].toString(),
//                                                     )), (route) => false);
//                                               },
//                                               title: Text('${electionsnapshot.data![0][0]} ', style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold),),
//                                               subtitle: Text('election $i'),
//                                               trailing: const Icon(Icons.poll_outlined),
//                                             ),
//                                           );
//                                         }
//                                       })
//                               ],
//                             );
//                           }
//                         } catch (e) {
//                           return Center(//if the call gets exception
//                             child:
//                             Text("Cannot acess this page for now $e"),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Container(
//         decoration:  const BoxDecoration(gradient:
//         LinearGradient(colors: [
//           Color(0xFF516395),
//           Color(0xFF614385 ),
//         ])),
//         child: Scaffold(
//           appBar: AppBar(
//             leading: IconButton(
//               onPressed: () {
//                 signOut();
//               },
//               icon: const Icon(Icons.logout),
//             ),
//             actions: [
//               IconButton(
//                   onPressed: () {
//                     setState(() {});
//                   },
//                   icon: const Icon(Icons.refresh))
//             ],
//             title: const Text('Voter Pick Election'),
//             backgroundColor: Colors.transparent,
//           ),
//           body:  SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 56),
//                   child: SingleChildScrollView(
//                     child: StreamBuilder<List>(
//                       stream:
//                       getElectionCounts(ethclient!, contractAdressConst)
//                           .asStream(),
//                       builder: (context, snapshot) {
//                         try {
//                           if(snapshot.data![0].toInt() == null){
//                             return const Center(
//                               child: Text('there is no data for now'),
//                             );
//                           }else if (snapshot.connectionState == ConnectionState.waiting) {
//                             return const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                           } else if (snapshot.data![0].toInt() == 0) {
//                             return const Center(
//                               child: Text("no elections for now "),
//                             );
//                           } else {
//                             return Column(
//                               children: [
//                                 for (int i = 0;
//                                 i < snapshot.data![0].toInt();
//                                 i++)
//                                   FutureBuilder<List>(
//                                       future: getDeployedElection(i, ethclient!, contractAdressConst),
//                                       builder: (context, electionsnapshot) {
//                                         if (electionsnapshot
//                                             .connectionState ==
//                                             ConnectionState.waiting) {
//                                           return const Center(
//                                             child:
//                                             CircularProgressIndicator(),
//                                           );
//                                         } else {
//                                           if (kDebugMode) {
//                                             print('${electionsnapshot.data}');
//                                           }
//                                           return Container(
//                                             padding: const EdgeInsets.all(12),
//                                             margin: const EdgeInsets.all(12),
//                                             decoration: const BoxDecoration(
//                                                 boxShadow: [
//                                                   BoxShadow(color: Color(0xFF7F5A83),
//                                                     offset: Offset(-11.9, -11.9),
//                                                     blurRadius: 39,
//                                                     spreadRadius: 0.0,
//                                                   ),
//                                                   BoxShadow(color: Color(0xFF7F5A83),
//                                                     offset: Offset(11.9, 11.9),
//                                                     blurRadius: 39,
//                                                     spreadRadius: 0.0,
//                                                   ),
//                                                 ],
//                                                 borderRadius: BorderRadius.all(Radius.circular(10)),
//                                                 gradient: LinearGradient(colors: [
//                                                   Color(0xFF74F2CE),
//                                                   Color(0xFF7CFFCB),
//                                                 ])),
//                                             child: ListTile(
//                                               tileColor: Colors.transparent,
//                                               onTap: ()async {
//                                                 await checkElecStatus(electionsnapshot.data![0][0]);
//                                                 if(_electiondata[0] != null){
//                                                   goVoterHome(electionsnapshot.data![0][0],electionsnapshot.data![0][1].toString());
//                                                 }else{
//                                                   if (kDebugMode) {
//                                                     print('no election data');
//                                                   }
//                                                 }
//                                               },
//                                               title: Text('${electionsnapshot.data![0][0]} ',
//                                                 style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold),),
//                                               subtitle: Text('election $i'),
//                                               trailing: const Icon(Icons.poll_outlined),
//                                             ),
//                                           );
//                                         }
//                                       })
//                               ],
//                             );
//                           }
//                         } catch (e) {
//                           return Center(
//                             child:
//                             Text("Cannot acess this page for now $e"),
//                           );
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
//   }
//
//
//   final List<dynamic> _electiondata = [];
//
//   String? _startdate ;
//   String? _enddate ;
//   String? _state ;
//   bool? _ended ;
//
//   Future<void>checkElecStatus(String electionName)async {
//     try {
//       final DocumentSnapshot election = await FirebaseFirestore.instance
//           .collection('Election')
//           .doc(electionName)
//           .get();
//       if (election.data() != null) {
//         _electiondata.clear();
//         _ended = election.get('endedElection');
//         _startdate = election.get('startdate');
//         _enddate = election.get('enddate');
//         _state = election.get('state');
//         _electiondata.addAll([_ended!,_startdate!,_enddate!,_state!]);
//         if (kDebugMode) {
//           print('$_electiondata');
//         }
//       }else{
//         if (kDebugMode) {
//           print('cannot find details');
//         }
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print('get check user ::::: $e');
//         if(!mounted)return;
//         snackbarshow().showSnackBar(snackbarshow().errorSnack, context);
//       }
//     }
//   }
//
//   void goVoterHome(String? electionName,String? electionAddress){
//     Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context) =>
//         VoterHome(ethClient: ethclient!,electionName:electionName!,
//           electionaddress:electionAddress!, electiondata:_electiondata,
//         )),
//             (route) => false);
//
//   }
//
// }
