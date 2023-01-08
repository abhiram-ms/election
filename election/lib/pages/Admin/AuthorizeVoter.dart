import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/services/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

import '../../services/Auth.dart';
import '../../utils/Constants.dart';
import '../../services/IntoLogin.dart';

class AuthorizeVoter extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionAddress;
  const AuthorizeVoter(
      {Key? key,
      required this.ethClient,
      required this.electionName,
      required this.electionAddress})
      : super(key: key);

  @override
  State<AuthorizeVoter> createState() => _AuthorizeVoterState();
}

class _AuthorizeVoterState extends State<AuthorizeVoter> {
  //firebase auth instance initialization
  final User? user =
      Auth().currentuser; //firebase auth current user initialization

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

//refresh function
  void refresh() {
    setState(() {});
  }

  Future<void> registerAuth(String adhar) async {
    try {
      await FirebaseFirestore.instance
          .collection('Election')
          .doc(widget.electionName)
          .collection('voterAuth')
          .doc(adhar)
          .update({'isAuth': true});
      print('updated data aaaaaaaaaaaaaaa');
      showSnackBar(succesAdharSnack);
    } catch (e) {
      if (kDebugMode) {
        print('failed to register on firebase $e');
      }
      showSnackBar(errorAdharSnack);
    }
  }

  //text editing controller
  TextEditingController voterAdressController = TextEditingController();
  TextEditingController voterAdharController = TextEditingController();

  //variables declared
  late int _adharage = 19;
  late bool _is_adhar_verified = false;
  late int _adharnum = 12345678;

  Future<void> getAdharVerified(String adharnum) async {
    try {
      final DocumentSnapshot Adhars = await FirebaseFirestore.instance
          .collection('Adhars')
          .doc(adharnum)
          .get();
      if (Adhars.data() != null) {
        _adharage = Adhars.get('age');
        _is_adhar_verified = Adhars.get('verified');
        _adharnum = Adhars.get('adharnum');
        showSnackBar(succesAdharSnack);
      }
    } catch (e) {
      if (kDebugMode) {
        print('get adhar verified failed ::::: $e');
      }
      showSnackBar(errorAdharSnack);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFF516395),
        Color(0xFF614385),
      ])),
      child: Scaffold(
        appBar: AppBar(
          ///app bar
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              signOut();
            },
            icon: const Icon(Icons.logout_sharp),
          ),
          title: const Text(
            'Authorize Voter',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  refresh();
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Election')
              .doc(widget.electionName)
              .collection('voterAuth')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              print('we got no dataaaaaaaaa');
              return const Center(
                child: Text('Voters Not Registered yet',
                    style: TextStyle(color: Colors.white)),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.data != null) {
                print('we haveeeeeeeeee daaaaattaaaaa$snapshot');
                return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      var data = Map<String, dynamic>.from(
                          snapshot.data?.docs[index].data() as Map);
                      print(data);
                      print(data["voterAge"]);
                      var adhar = data["adharnum"];
                      var voterAdress = data["voterAddress"];
                      var voterage = int.parse(data["voterAge"].toString());
                      var email = data["email"];
                      print('adhaaaarrrrrrrrrrrrrrrr ===== ${adhar}');
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12, top: 12),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Container(
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
                            title: Text(
                              data["voterName"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.purple),
                            ),
                            subtitle: Text(
                              'age : ${data["voterAge"]}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.purple),
                            ),
                            leading: Text(index.toString(),
                                style: const TextStyle(color: Colors.purple)),
                            trailing: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      voterage >= 18
                                          ? Icons.check
                                          : Icons.warning_amber,
                                      color: voterage >= 18
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: Text(
                                      "Authorize",
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                if (voterAdress != null && voterage >= 18) {
                                  try {
                                    await bigAuthorize(voterAdress, adhar);
                                    showSnackBar(succesAuthSnack);
                                  } catch (e) {
                                    showSnackBar(errorAuthSnack);
                                    if (kDebugMode) {
                                      print('failed due to :::::: $e');
                                    }
                                  }
                                } else {
                                  showSnackBar(errorAdharSnack);
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: Text('Voters are Not Registered Yet'),
                );
              }
            }
          },
        ),
      ),
    );
  }

  //snackbar
  SnackBar errorAdharSnack = const SnackBar(
      content: Text('Adhar verification failed make sure details are right'));
  SnackBar succesAdharSnack =
      const SnackBar(content: Text('Adhar verification successfull'));
  SnackBar errorAuthSnack = const SnackBar(
      content: Text('Unsuccessfull metamask adress is not valid'));
  SnackBar succesAuthSnack =
      const SnackBar(content: Text('Voter Authorization Successfull'));
  SnackBar errorSnack = const SnackBar(content: Text('Fill all the details'));
  SnackBar datanullSnack =
      const SnackBar(content: Text('No users registerd yet'));

  //function to show snackbar
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      SnackBar snackBar) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bigAuthorize(String voterAdress, String adhar) async {
    await authorizeVoter(voterAdress, widget.ethClient, owner_private_key,
        widget.electionAddress);
    registerAuth(adhar);
  }
}
