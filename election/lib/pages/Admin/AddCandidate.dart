import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Admin/AuthorizeVoter.dart';
import 'package:election/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/Auth.dart';
import '../../services/functions.dart';
import '../../services/IntoLogin.dart';

class AddCandidate extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionAdress;
  const AddCandidate({Key? key, required this.ethClient, required this.electionName, required this.electionAdress}) : super(key: key);

  @override
  State<AddCandidate> createState() => _AddCandidateState();
}

class _AddCandidateState extends State<AddCandidate> {

//firebase auth instance initialization
  final User? user = Auth()
      .currentuser; //fi// rebase auth current user initialization

  //sign out user function
  Future<void> signOut() async {
    if (!mounted) return;
    await Auth().signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => IntroLogin()),
            (route) => false);
  }

  //variables declared
  late int _adharage = 19;
  late bool _is_adhar_verified = false;
  late int _adharnum = 12345678;

//get adhar verification function to get adhar details of the candidate
  Future<void> getAdharVerified(String adharnum) async {
    try {
      final DocumentSnapshot Adhars = await FirebaseFirestore.instance
          .collection('Adhars')
          .doc(adharnum)
          .get();
      if (Adhars.data() != null) {
        _adharage = Adhars.get('age'); //assign adhars age to adharage
        _is_adhar_verified =
            Adhars.get('verified'); //assign if the adhar verified or not
        _adharnum = Adhars.get('adharnum'); //store adharnum in this variablee
        showSnackBar(succesAdharSnack); //show snackbar
      }
    } catch (e) {
      if (kDebugMode) {
        print('get adhar verified failed ::::: $e');
      }
      showSnackBar(errorAdharSnack);
    }
  }
  final formKey = GlobalKey<FormState>();

  TextEditingController candidateNameController = TextEditingController();
  TextEditingController candidateAdharController = TextEditingController();
  TextEditingController AdminmtmskController = TextEditingController();

  //to refresh to see added details
  void refresh() {
    setState(() {});
  }

  late int numberOfCandidates;

  SnackBar errorAdharSnack = const SnackBar(
      content: Text('Adhar verification failed make sure details are right'));
  SnackBar succesAdharSnack = const SnackBar(
      content: Text('Adhar verification successfull'));
  SnackBar errorSnack = const SnackBar(content: Text('Fill all the details'));

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      SnackBar snackBar) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          leading: IconButton(onPressed: () {
            signOut();
          }, icon: const Icon(Icons.logout_sharp),),
          title: const Text('Add Candidate'),
          actions: [
            IconButton(onPressed: () {
              refresh();
            }, icon: const Icon(Icons.refresh))
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(padding: const EdgeInsets.all(24),
                    child: Form(key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 24,),
                          SelectableText(owner_private_key),
                          const SizedBox(height: 24,),
                          const SizedBox(height: 16,),
                          Container(padding: const EdgeInsets.all(16),
                            child: TextFormField(
                              validator: (value){
                                if(value == null||value.isEmpty){
                                  return 'please enter the details';
                                }
                                return null;
                              },
                              controller: candidateNameController,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Candidate Name',border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)))
                              ),
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Container(padding: const EdgeInsets.all(16),
                            child: TextFormField(
                              validator: (value){
                              if(value == null||value.isEmpty){
                              return 'please enter the details';
                              }
                              return null;
                              },
                              controller: candidateAdharController,
                              decoration: const InputDecoration(
                                  hintText: 'Enter Candidate Adhar Num',border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)))
                              ),
                            ),
                          ),
                          const SizedBox(height: 16,),
                          Container(padding: const EdgeInsets.all(16),
                            child: TextFormField(
                              validator: (value){
                                if(value == null||value.isEmpty){
                                  return 'please enter the details';
                                }
                                return null;
                              },
                              controller: AdminmtmskController,
                              decoration: const InputDecoration(
                                  hintText: 'Enter admins metamask private key',border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8)))
                              ),
                            ),
                          ),
                          const SizedBox(height: 24,),
                          ElevatedButton(onPressed: () async {
                            if (formKey.currentState!.validate()){
                              await getAdharVerified(candidateAdharController.text);
                              candidateAdharController.clear();
                                if (_adharage >= 18) {
                                  addCandidate(candidateNameController.text, widget.ethClient, AdminmtmskController.text, widget.electionAdress);
                                  candidateNameController.clear();
                                } else {
                                  showSnackBar(errorAdharSnack);
                                }
                            } else {
                              showSnackBar(errorSnack);
                            }
                          }, child: const Text('Add Candidate'))
                        ],
                      ),
                    ),
                  ),
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
          ],
        )
    );
  }
}
