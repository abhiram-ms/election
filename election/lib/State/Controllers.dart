import 'package:election/Firebase/firebase_api.dart';
import 'package:get/get.dart';

import '../Firebase/firebase_file.dart';
import '../pages/Admin/closeElection.dart';

class CloseElecController extends GetxController{
  late Future<List<FirebaseFile>> futureFiles;
  // void refresh() {
  //   setState(() {
  //   });
  // }
  // Future<void> signOut() async {
  //   if (!mounted) return;
  //   await Auth().signOut();
  //   if (!mounted) return;
  //   Navigator.pushAndRemoveUntil(
  //       context,
  //       MaterialPageRoute(builder: (context) => IntroLogin()),
  //           (route) => false);
  // }

  late String winner = 'No candidate';
  String? download;
  late int winnervotes = 0;
  late int row = 5;
  late int col = 5;
// var candidatearray = [] ;
// var candidatearrayreal = [] ;

  final Set<Candidates> _candidateset = {}; // your data goes here

@override
  void onInit() {
  //futureFiles = FirebaseApi.listAll('electionimages/${}/partyimages/candidates');
  _candidateset.clear();
    super.onInit();
  }


}