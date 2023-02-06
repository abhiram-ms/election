import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../Firebase/firebase_api.dart';
import '../../Firebase/firebase_file.dart';
import '../../services/Auth.dart';
import '../../services/IntoLogin.dart';
import '../../services/functions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CloseElec extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionAdress;
  const CloseElec({Key? key, required this.ethClient, required this.electionName, required this.electionAdress}) : super(key: key);

  @override
  State<CloseElec> createState() => _CloseElecState();
}

class _CloseElecState extends State<CloseElec> {
  late Future<List<FirebaseFile>> futureFiles;
  void refresh() {
    setState(() {
    });
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
  String? download;
late int winnervotes = 0;
late int row = 5;
late int col = 5;
// var candidatearray = [] ;
// var candidatearrayreal = [] ;

  final Set<Candidates> _candidateset = {}; // your data goes here

@override
  void initState() {
  futureFiles = FirebaseApi.listAll('electionimages/${widget.electionName}/partyimages/candidates');
    _candidateset.clear();
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
        body: SingleChildScrollView(  //Here we are getting the whole candidate details
          child: Column(
            children: [
              const SizedBox(height: 24,),
              FutureBuilder<List<FirebaseFile>>(
                future: futureFiles,
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
                  child: StreamBuilder<List>(stream: getCandidatesNum(widget.ethClient, widget.electionAdress).asStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(),);//circular bar for waiting
                      } else {
                        return Column(
                          children: [  // here we will get all candidates using a loop
                            for (int i = 0; i < snapshot.data![0].toInt(); i++)
                              FutureBuilder<List>(  // call to get candidate info
                                  future: candidateInfo(i, widget.ethClient, widget.electionAdress),
                                  builder: (context, candidatesnapshot) {
                                    if (candidatesnapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator(),);
                                    } else {
                                      // logic to decide the winner
                                      if(candidatesnapshot.data![0][1].toInt() > winnervotes){
                                        winnervotes = candidatesnapshot.data![0][1].toInt();
                                        winner = candidatesnapshot.data![0][0];
                                      }else if(candidatesnapshot.data![0][1].toInt() == winnervotes){
                                        winner = candidatesnapshot.data![0][0];
                                      }
                                      // candidatearrayreal.add(candidatesnapshot.data);
                                      Candidates candidate = Candidates(name:candidatesnapshot.data![0][0],
                                          votes:int.parse(candidatesnapshot.data![0][1].toString()));
                                      _candidateset.add(candidate);
                                     // print(candidatesnapshot.data);
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
              const SizedBox(height: 16,),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      FutureBuilder<List>(
                          future: getCandidatesNum(
                              widget.ethClient, widget.electionAdress),
                          builder: (context, numsnapshot) {
                            if (numsnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return Text(
                              numsnapshot.data![0].toString(),
                              style: const TextStyle(
                                  fontSize: 50, fontWeight: FontWeight.bold,color: Colors.white),
                            );
                          }),
                      const Text('Total Candidates',style: TextStyle(color: Colors.white))
                    ],
                  ),
                  const SizedBox(height: 24,),
                  Column(
                    children: [
                      FutureBuilder<List>(
                          future: getTotalVotes(
                              widget.ethClient, widget.electionAdress),
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
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  children: [
                    SfCircularChart(
                      title: ChartTitle(text: 'Voters with votes'),
                      legend:Legend(isVisible: true,overflowMode:LegendItemOverflowMode.wrap) ,
                      series: <CircularSeries>[
                            PieSeries<Candidates,String>(
                                dataSource: _candidateset.toList(),
                                xValueMapper:(Candidates data,_)=>data.name,
                                yValueMapper: (Candidates data,_)=>data.votes,
                                dataLabelSettings: const DataLabelSettings(isVisible: true)
                            )
                          ],
                    ),
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

class Candidates {
  final String name;
  final int votes;

  Candidates({required this.name, required this.votes});

  @override
  bool operator ==(covariant Candidates other) {
    if (identical(this, other)) return true;
    return
      other.name == name &&
          other.votes == votes ;
  }

  @override
  int get hashCode {
    return name.hashCode ^
    votes.hashCode;
  }

}
//
// FutureBuilder<List>(  // call to get candidate info
// future: candidateInfo(i, widget.ethClient, widget.electionAdress),
// builder: (context, candidatesnapshot) {
// if (candidatesnapshot.connectionState == ConnectionState.waiting) {
// return const Center(child: CircularProgressIndicator(),);
// } else {
// // logic to decide the winner
// if(candidatesnapshot.data![0][1].toInt() > winnervotes){
// winnervotes = candidatesnapshot.data![0][1].toInt();
// winner = candidatesnapshot.data![0][0];
// }else if(candidatesnapshot.data![0][1].toInt() == winnervotes){
// winner = candidatesnapshot.data![0][0];
// }
// // candidatearrayreal.add(candidatesnapshot.data);
// Candidates candidate = Candidates(name:candidatesnapshot.data![0][0],
// votes:int.parse(candidatesnapshot.data![0][1].toString()));
// _candidateset.add(candidate);
// print(candidate.name);
// print(candidate.votes);
// // print(candidatesnapshot.data);
// return Container(
// padding: const EdgeInsets.all(12),
// margin: const EdgeInsets.all(12),
// decoration: const BoxDecoration(
// boxShadow: [
// BoxShadow(color: Color(0xFF7F5A83),
// offset: Offset(-11.9, -11.9),
// blurRadius: 39,
// spreadRadius: 0.0,
// ),
// BoxShadow(color: Color(0xFF7F5A83),
// offset: Offset(11.9, 11.9),
// blurRadius: 39,
// spreadRadius: 0.0,
// ),
// ],
// borderRadius: BorderRadius.all(Radius.circular(10)),
// gradient: LinearGradient(colors: [
// Color(0xFF74F2CE),
// Color(0xFF7CFFCB),
// ])),
// child: ListTile(
// title: Text('Name: ${candidatesnapshot.data![0][0]}',
// style: const TextStyle(color: Colors.purple)),
// subtitle: Text('Votes: ${candidatesnapshot.data![0][1]}',
// style: const TextStyle(color: Colors.purple)),
// ),
// );
// }
// })

