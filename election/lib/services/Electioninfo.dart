import 'package:election/services/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionAddress;
  const ElectionInfo(
      {Key? key,
      required this.ethClient,
      required this.electionName,
      required this.electionAddress})
      : super(key: key);

  @override
  _ElectionInfoState createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();

   int candidatesnum = 0;

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
          title: Text(widget.electionName),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(14),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          candidatesnum.toString(),
                          style: const TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                        const Text('Total Candidates',style: TextStyle(color: Colors.white))
                      ],
                    ),
                    const SizedBox(height: 24,),
                    Column(
                      children: [
                        FutureBuilder<List>(
                            future: getTotalVotes(
                                widget.ethClient, widget.electionAddress),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Text(
                                snapshot.data![0].toString(),
                                style: const TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold,color: Colors.white),
                              );
                            }),
                        const Text('Total Votes',style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(),
                Container(alignment: Alignment.centerLeft,child: const Text('Candidates Info',style: TextStyle(color: Colors.white))),
                const SizedBox(height: 24,),
                Container(margin: const EdgeInsets.only(bottom: 56),
                  child: SingleChildScrollView(
                    child: StreamBuilder<List>(stream: getCandidatesInfoList(
                        widget.ethClient, widget.electionAddress).asStream(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }else if(snapshot.hasError){
                          Get.snackbar('Error ','cannot fetch data at the moment');
                          return const Center(child: Text('Error : Cannot fetch data at the moment',style: TextStyle(color: Colors.white),));
                        } else if(snapshot.hasData){
                          if(snapshot.data!.isEmpty){
                            return const Center(child: Text('There is no election at the moment',style: TextStyle(color: Colors.white),));
                          }else{
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                  itemCount: snapshot.data![0][0].length,
                                  itemBuilder: (context,index){
                                    candidatesnum = snapshot.data![0][0].length;
                                    if (kDebugMode) {
                                      print('....1 ${snapshot.data![0]}');
                                    }
                                    if (kDebugMode) {
                                      print('....2 ${snapshot.data![0][0]}');
                                    }
                                    if (kDebugMode) {
                                      print('....3 ${snapshot.data![0][0][0]}');
                                    }
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
                                        onTap: () {
                                          // Get.offAll(()=>DashBoard(
                                          //     ethClient:homeController.ethclient!,
                                          //     electionName: snapshot.data![0][index][0],
                                          //     electionaddress: snapshot.data![0][index][1].toString()));
                                        },
                                        title: Text('${snapshot.data![0][index][0]}', style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold),),
                                        subtitle: Text('candidate  $index'),
                                        trailing: const Icon(Icons.poll_outlined),
                                      ),
                                    );
                                  }),
                            );
                          }
                        }else{
                          Get.snackbar('Error ','cannot fetch data at the moment');
                          return  const Center(child: Text('Cannot fetch data at the moment',style: TextStyle(color: Colors.white),));
                        }
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
