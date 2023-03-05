import 'package:election/services/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:web3dart/web3dart.dart';
import '../Models/Firebase/firebase_file.dart';
import '../Models/candidates_model.dart';
import '../State/homeController.dart';
import '../pages/Admin/closeElection.dart';

class ElectionInfo extends StatelessWidget {
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
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    homeController.initialize();
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
            homeController.signOut();
          }, icon: const Icon(Icons.logout_sharp),),
          title: const Text('Election progress'),
          actions: [
            IconButton(onPressed: () {
            }, icon: const Icon(Icons.refresh))
          ],
        ),
        body: SingleChildScrollView(  //Here we are getting the whole candidate details
          child: Column(
            children: [
              const SizedBox(height: 24,),
              FutureBuilder<List<FirebaseFile>>(
                future: homeController.futureFiles,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      if (snapshot.hasError) {
                        return const Center(child: Text('Some error occurred!'));
                      } else {
                        final files = snapshot.data!;

                        return SizedBox(height: 150,width: 400,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: files.length,
                                  itemBuilder: (context, index) {
                                    final file = files[index];
                                    return buildFile(context, file);
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  }
                },
              ),
              Container(margin: const EdgeInsets.only(bottom: 56),
                child: SingleChildScrollView(  // this stream builder will give the number of items/candidates
                  child: StreamBuilder<List>(stream: getCandidatesInfoList(
                      ethClient, electionAddress).asStream(),
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
                            child: ListView.builder(
                                itemCount: snapshot.data![0].length,
                                shrinkWrap: true,
                                itemBuilder: (context,index){

                                  Candidates candidates = Candidates(
                                      name:snapshot.data![0][index][0],
                                      votes:snapshot.data![0][index][1].toInt());

                                  // print(candidatesnapshot.data);
                                  if (kDebugMode) {
                                    print('....1 ${snapshot.data![0]}');
                                  }
                                  if (kDebugMode) {
                                    print('....2 ${snapshot.data![0][0]}');
                                  }
                                  if (kDebugMode) {
                                    print('....3 ${snapshot.data![0][0][0]}');
                                  }

                                  //calculating leader
                                  homeController.calculateLeader(candidates,snapshot.data![0][0].length);
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
              const SizedBox(height: 12,),
              GetBuilder<HomeController>(builder:(_)=>
                  Text('The leading candidate of the election is : ${homeController.winner} with votes ${homeController.winnervotes}',
                      style: const TextStyle(color: Colors.white)),),
              const SizedBox(height: 16,),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      GetBuilder<HomeController>(builder: (_)=>Text(
                        homeController.candidatesNum.toString(),
                        style: const TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold,color: Colors.white),
                      ),),
                      const Text('Total Candidates',style: TextStyle(color: Colors.white))
                    ],
                  ),
                  const SizedBox(height: 24,),
                  Column(
                    children: [
                      FutureBuilder<List>(
                          future: getTotalVotes(
                              ethClient, electionAddress),
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
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    GetBuilder<HomeController>(builder: (_)=>SfCircularChart(
                      title: ChartTitle(text: 'Voters with votes'),
                      legend:Legend(isVisible: true,overflowMode:LegendItemOverflowMode.wrap) ,
                      series: <CircularSeries>[
                        PieSeries<Candidates,String>(
                            dataSource: homeController.candidateset.toList(),
                            xValueMapper:(Candidates data,_)=>data.name,
                            yValueMapper: (Candidates data,_)=>data.votes,
                            dataLabelSettings: const DataLabelSettings(isVisible: true)
                        )
                      ],
                    ),)
                  ],
                ),
              ),
              const SizedBox(height: 16,)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => SizedBox(
    height: 150,width: 150,
    child: Column(
      children: [
        ClipOval(
          child: Image.network(
            file.url,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          file.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ],
    ),
  );

}
