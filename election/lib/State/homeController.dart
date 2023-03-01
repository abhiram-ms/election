import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/services/Pickelection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import '../services/Auth.dart';
import '../services/IntoLogin.dart';
import '../services/functions.dart';
import '../utils/Constants.dart';

class HomeController extends GetxController{

  @override
  void onInit() {
    usernow = auth.currentUser!;
    httpClient = Client();
    ethclient = Web3Client(infura_url, httpClient!);
    try {
      getData();
    } catch (e) {
      isTrue = false;
    }
    super.onInit();
  }
//-----------------------------------------------------------------------------> ADMIN HOME(START ELECTION)
  //creating clients
  late Client? httpClient;
  late Web3Client? ethclient;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentuser => _firebaseAuth.currentUser;

  //INITIATE FIREBASE AUTH
  final auth = FirebaseAuth.instance;

  //CURRENT USER
  late User usernow;

  //variables used
  late String? userEmail = currentuser?.email; //EMAIL OF CURRENT USER
  late String adminName = 'admin';
  late bool isTrue = false;
  late String phone = 'not fetched';
  late bool isAdharVerified = false;
  late bool startElection = false;

  //GET USER DATA FROM FIREBASE AUTHENTICATION
  Future<void> getData() async {//CHECKING ADMINS DATA IF THE ELECTION IS STARTED OR NOT
    try {
      final DocumentSnapshot admins = await FirebaseFirestore.instance
          .collection('Admins')
          .doc(userEmail!)
          .get();
      if (admins.data() != null) {
        adminName = admins.get('Name');
        isTrue = admins.get('Admin');
        phone = admins.get('phone');
        isAdharVerified = admins.get('adharverified');
        startElection = admins.get('electionStarted');
        // refresh();
      }
    } catch (e) {
      if (kDebugMode) {
        print('get data failed : :: :: : $e');
      }
    }
  }

  //date constants
  DateTime date = DateTime(2022, 12, 30);
  late String unix;
  late String unixlast;

  //get dates
  Future<void> getDate(BuildContext context,TextEditingController dateinput) async {
    DateTime? newdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (newdate == null) return;
    date = newdate;
    unix = DateTime(newdate.year, newdate.month, newdate.day)
        .millisecondsSinceEpoch
        .toString()
        .substring(0, 10);
    if (kDebugMode) {
      print('the unix time stamp is $unix');
    }
    dateinput.text = '${newdate.year}/${newdate.month}/${newdate.day}';
    update();
  }
  Future<void> getEndDate(BuildContext context,TextEditingController dateinputend) async {
    DateTime? newdatelast = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    );
    if (newdatelast == null) return;
    date = newdatelast;
    unixlast = DateTime(newdatelast.year,
        newdatelast.month, newdatelast.day)
        .millisecondsSinceEpoch
        .toString()
        .substring(0, 10);
    if (kDebugMode) {
      print('the unix time stamp is $unixlast');
    }
    dateinputend.text = '${newdatelast.year}/${newdatelast.month}/${newdatelast.day}';
    update();
  }


  //election functions
   late int adharage = 10;
   late int adharnum = 1234567890;

  //Start Election Complete
  void startElectionComplete(String adharnum,String electionName,String state,String district,String privateKey) async {
    // the code to start election from adhar verification,register election and create election at blockchain

    //adhar verification
    if (kDebugMode) {print('verifying adhar');}
    await getAdharVerified(adharnum); //ADHAR VERIFICATION FUNCTION
    if (kDebugMode) {print('adhar verified');}

    // CHECKING AGE FROM AADHAAR
    if (adharage > 18 ) {
      if (kDebugMode) {print('adhar verification complete');} // CHECKING WEATHER ELECTION DATES ARE GIVEN
      if (unixlast.isNotEmpty && unix.isNotEmpty) {
        if (kDebugMode) {print('unix not nulll');}

        try {
          //Registering election
          if (kDebugMode) {print('registering');}
         // await registerElec(unix, unixlast,electionName,state,district); // REGISTERING THE ELECTION IN FIREBASE
          if (kDebugMode) {print('creating blockchain');}

          //AFTER REGISTRATION CREATING ELECTION ON BLOCKCHAIN
          loadingBar();
         // await createElection(electionName, ethclient!, privateKey, contractAdressConst);
          loadingBarOff();
          gotoPickElec();

        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          Get.snackbar('error occured', '$e');
        }
      }else{Get.snackbar('error occured', 'error fill all details');}
    }else{Get.snackbar('error occurred', 'error fill all details');}
    loadingBarOff();
  }

  //Register election
  Future<void> registerElec(String timestampStart, String timestampEnd,String electionName,String state,String district) async {
    if (kDebugMode) {
      print('reg elec');
    }
    loadingBar();
    final CollectionReference election = FirebaseFirestore.instance.collection('Election');

    try {
      await election.doc(electionName).set({
        "startdate": timestampStart,
        "enddate": timestampEnd,
        "name": electionName,
        "state": state,
        "district":district,
        "endedElection":false,
      });
      if (kDebugMode) {
        print('user added successfullyyyyyyy');
      }
    } catch (err) {
      Get.snackbar('error occured', '$err');
    }
    loadingBarOff();
  }

  //Go to pick election
  void gotoPickElec() {
    Get.offAll(()=> const Pickelec(admin: true));
  }

  //loading bar variable
  bool isLoading = false;
  void loadingBar(){
    isLoading = true;
    update();
  }
  void loadingBarOff(){
    isLoading = false;
    update();
  }

  //---------------------------------->ADHAR VERIFICATION

  //AADHAAR VERIFICATION FROM FIREBASE
  Future<void> getAdharVerified(String adharnum) async {
    adharBar();
    try {
      final DocumentSnapshot adhars = await FirebaseFirestore.instance
          .collection('Adhars')
          .doc(adharnum)
          .get();
      if (adhars.data() != null) {
        //IF THE DATA IS NOT NULL
        adharage = adhars.get('age');
        adharnum = adhars.get('adharnum');
        Get.snackbar('success', 'successfully completed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('get adhar verified failed ::::: $e');
      }
      Get.snackbar('error', 'Adhar verification Failed :( ');
    }
    adharBarOff();
  }

  //adhar verifying bar
  bool isaAdharVerifying = false;
  void adharBar(){
    isaAdharVerifying = true;
    update();
  }
  void adharBarOff(){
    isaAdharVerifying = false;
    update();
  }

  //------------------------------------------------------------------->>>>>>>>>>> Sign out function
  Future<void> signOut() async {
    await Auth().signOut();
    Get.offAll(()=> const IntroLogin());
  }
  ////------------------------------------------------------------------>>>>>>> PICK ELECTION CONTROLLER

//loading bar variable
  bool isFetching = false;
  void fetching(){
    isFetching = true;
    update();
  }
  void fetchingOff(){
    isFetching = false;
    update();
  }

  ////------------------------------------------------------------------->>>>>>>>>>>Add Candidate Controller

  late int numberOfCandidates;
  late File? filetodisplay;
  late bool isselected = false;
  late bool isloading = false;
  UploadTask? uploadTask;

//function to pick files to upload
  Future<void> pickCandidatePhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      filetodisplay = File(file.path.toString());
      //String filename = file.name.toString();
      isselected=true;
      update();

      if (kDebugMode) {
        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
      }
    } else {
      isselected=false;
      // User canceled the picker
    }

  }

  // Getting adhar verified for candidate :::
  //variables declared
  late int adharAge;
  late int adharnumCandidate;
  late String name;
  late String address;
  late String mobile;
  late String email;
  late String district;
  late String state;
  late String dob;
  late bool adharVerified;

//get adhar verification function to get adhar details of the candidate
  Future<void> getAdharVerifiedCandidate(String adharnum) async {
    try {
      adharBar();
      final DocumentSnapshot adhars = await FirebaseFirestore.instance
          .collection('Adhars')
          .doc(adharnum)
          .get();
      if (adhars.data() != null) {
        adharAge = adhars.get('age'); //assign adhars age to adharage
        adharnumCandidate = adhars.get('adharnum'); //store adharnum in this variablee
        name = adhars.get('name');
        address = adhars.get('address');
        district = adhars.get('district');
        state = adhars.get('state');
        email = adhars.get('email');
        mobile = adhars.get('mobileNum');
        dob = adhars.get('dob');
        update();
        adharBarOff();
      }
    } catch (e) {
      adharBarOff();
      if (kDebugMode) {
        print('get adhar verified failed ::::: $e');
      }
      Get.snackbar('Error','Verifying adhar has an error');
    }
  }

  //function to add candidate
  Future<void> addCandidateAndUpload(Map<String,dynamic> candidateData,String electionName,String electionAdress,String mtmskKey) async {
   adharBar();
    await uploadImageAndData(candidateData,electionName).then((value) => {
      addCandidate(candidateData["Name"],ethclient!,mtmskKey, electionAdress),
    });
    adharBarOff();
  }

  //function to upload image and documents
  Future<void> uploadImageAndData(Map<String,dynamic> candidateData,String electionName) async{
    //file path and reference to storage
    final String filepath = 'electionimages/$electionName/partyimages/candidates/${candidateData["Name"]}/';
    final storageref = FirebaseStorage.instance.ref().child(filepath);
    //reference to add data to collection
    final DocumentReference candidate = FirebaseFirestore.instance.collection('Election').doc(electionName)
        .collection('candidates').doc(candidateData["adharnum"]);
    try{
      adharBar();
      //uploading picture
      uploadTask = storageref.putFile(filetodisplay!) ;
      //final snapshot = await uploadTask?.whenComplete((){});
      //uploading data
      await candidate.set({
        "Name":candidateData["Name"].text.toString(),"Age":candidateData["Age"],"adharnum":candidateData["adharnum"],
        "party":candidateData["party"],"email":candidateData["email"],
        "phonenum":candidateData["phonenum"],"district":candidateData["district"],"state":candidateData["state"],
        "address":candidateData["address"],"dob":candidateData["dob"],
      });
      //clearing controllers
      if (kDebugMode) {
        print('succcessssssssssss');
      }
    }catch(e){
      adharBarOff();
      if (kDebugMode) {
        print('whaat went wronggg :::: $e');
      }
    }
  }



}