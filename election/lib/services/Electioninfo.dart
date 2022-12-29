import 'package:election/services/functions.dart';
import 'package:election/utils/Constants.dart';
import 'package:flutter/material.dart';
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

   int candidatesnum = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
        backgroundColor: Colors.cyan,
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
                      FutureBuilder<List>(
                          future: getCandidatesNum(
                              widget.ethClient, widget.electionAddress),
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
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            );
                          }),
                      const Text('Total Candidates')
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
                                  fontSize: 50, fontWeight: FontWeight.bold),
                            );
                          }),
                      const Text('Total Votes')
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(),
              Container(alignment: Alignment.centerLeft,child: const Text('Candidates Info')),
              const SizedBox(height: 24,),
              Container(margin: const EdgeInsets.only(bottom: 56),
                child: SingleChildScrollView(
                  child: StreamBuilder<List>(stream: getCandidatesNum(
                      widget.ethClient, widget.electionAddress).asStream(),
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
                                      widget.electionAddress),
                                  builder: (context, candidatesnapshot) {
                                    if (candidatesnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      print(candidatesnapshot.data);
                                      return ListTile(
                                        title: Text('Name: ${candidatesnapshot.data![0][0]}'),
                                        subtitle: Text('Votes: ${candidatesnapshot.data![0][1]}'),
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

            ],
          ),
        ),
      ),
    );
  }
}
