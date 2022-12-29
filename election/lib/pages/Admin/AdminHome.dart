import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Admin/AddCandidate.dart';
import 'package:election/pages/Admin/DashBoard.dart';
import 'package:election/services/IntoLogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../services/Auth.dart';
import '../../services/Pickelection.dart';
import '../../services/functions.dart';
import '../../utils/Constants.dart';
import '../../services/Electioninfo.dart';
import '../../services/VerifyEmail.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  //creating clients
  late Client? httpClient;
  late Web3Client? ethclient;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentuser => _firebaseAuth.currentUser;

//INITIATE FIREBASE AUTH
  final auth = FirebaseAuth.instance;
  late User usernow; //CURRENT USER

  late String? userEmail = currentuser?.email; //EMAIL OF CURRENT USER
  late String adminName = 'admin';
  late bool _is_true = false;
  late String phone = 'not fetched';
  late bool _is_adhar_verified = false;
  late int _adharage = 10;
  late int _adharnum = 1234567890;
  late bool _startElection = false;

//GET USER DATA FROM FIREBASE AUTHENTICATION
  Future<void> getData() async {
    //CHECKING ADMINS DATA IF THE ELECTION IS STARTED OR NOT
    try {
      final DocumentSnapshot admins = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(userEmail!)
          .get();
      if (admins.data() != null) {
        adminName = admins.get('Name');
        _is_true = admins.get('Admin');
        phone = admins.get('phone');
        _is_adhar_verified = admins.get('adharverified');
        _startElection = admins.get('electionStarted');
        refresh();
      }
    } catch (e) {
      print('get data failed : :: :: : $e');
    }
  }

//ADHAR VERIFIACTION FROM FIREBASE
  Future<void> getAdharVerified(String adharnum) async {
    try {
      final DocumentSnapshot Adhars = await FirebaseFirestore.instance
          .collection('Adhars')
          .doc(adharnum)
          .get();
      if (Adhars.data() != null) {
        //IF THE DATA IS NOT NULL
        _adharage = Adhars.get('age');
        _adharnum = Adhars.get('adharnum');
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

  SnackBar errorAdharSnack = const SnackBar(
      content: Text('Adhar verification failed make sure details are right'));
  SnackBar succesAdharSnack =
      const SnackBar(content: Text('Adhar verification successfull'));
  SnackBar errorSnack = const SnackBar(content: Text(' some error occuered try again Fill all the details'));

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      SnackBar snackBar) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // final TextEditingController _electionNameController = TextEditingController();
  // final TextEditingController _adharnumController = TextEditingController();
  // final TextEditingController _NameController = TextEditingController();

  final User? user = Auth().currentuser;
  Future<void> signOut() async {
    if (!mounted) return;
    await Auth().signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => IntroLogin()),
        (route) => false);
  }

  @override
  void initState() {
    usernow = auth.currentUser!;
    httpClient = Client();
    ethclient = Web3Client(infura_url, httpClient!);
    try {
      getData();
    } catch (e) {
      _is_true = false;
    }
    super.initState();
  }

  TextEditingController adharTextController = TextEditingController();
  TextEditingController electionNameTextController = TextEditingController();
  TextEditingController privateKeyTextController = TextEditingController();

  void refresh() {
    setState(() {});
  }

  void gotoPickElec() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Pickelec(admin:true,)));
  }

  @override
  Widget build(BuildContext context) {
    if (usernow.emailVerified) {
      if (_is_true == true) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                signOut();
              },
              icon: const Icon(Icons.logout),
            ),
            title: const Text('ADMIN DASHBOARD'),
            backgroundColor: Colors.cyan,
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    refresh();
                  },
                  icon: const Icon(Icons.refresh))
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const Center(
                    child: SelectableText("f6468ec22fe10152849e4301db68f056933c5367832fa4dcd97e1e5a808834f3")
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(padding: const EdgeInsets.all(16),
                    child: TextField(
                        controller: adharTextController,
                        decoration:
                            const InputDecoration(hintText: 'Adhar Number',border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8))))),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: privateKeyTextController,
                      decoration: const InputDecoration(
                          hintText: 'Admins metamask private key',border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(8)))),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: electionNameTextController,
                      decoration:
                          const InputDecoration(hintText: 'Election name',border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(8)))),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (electionNameTextController.text.isNotEmpty && adharTextController.text.isNotEmpty) {
                          await getAdharVerified(adharTextController.text);
                          if (_adharage > 18 && privateKeyTextController.text.isNotEmpty) {
                            try{
                              await createElection(electionNameTextController.text, ethclient!, privateKeyTextController.text, contractAdressConst);
                              registerElec();
                              gotoPickElec();
                            }catch(e){
                              if (kDebugMode) {
                                print(e);
                              }
                              showSnackBar(errorAdharSnack);
                            }
                          }
                        } else {
                          showSnackBar(errorSnack);
                        }
                      },
                      child: const Text('Start Election'))
                ],
              ),
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            title: const Text('verify email'),
          ),
          body: Center(
            child: Column(
              children: const [
                Text('Loading ... If you are a voter Login as avoter'),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      }
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('verify email'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Your Email ${usernow.email} is not verified'),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerifyEmail()),
                        (route) => false);
                  },
                  child: const Text('Verify Email'))
            ],
          ),
        ),
      );
    }
  }

  Future<void> registerElec()async {
    final CollectionReference election =  FirebaseFirestore.instance.collection('Election');
    final CollectionReference voterAuth = election.doc(electionNameTextController.text.toString()).collection('voterAuth');

    try{
      await voterAuth.doc('123478901111').set({
        "adharnum":'Admin',"email":'email',"isAuth":false,"isVoted":false,
        "name":'aadmin',"voterAddress":'0xxxxxx',"voterAge":20,});
      print('user added successfullyyyyyyy');
    }catch(err){
      showSnackBar(errorSnack);
    }
  }

}
