
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:election/pages/Admin/DashBoard.dart';
import 'package:election/services/snackbar.dart';
import 'package:election/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:list_picker/list_picker.dart';
import 'package:file_picker/file_picker.dart';

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

  List<String> party = ['BJP','BSP','CPI','CPM','INC','NPC'];

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
  late int _adharage;
  late int _adharnum;
  late String name;
  late String address;
  late String mobile;
  late String email;
  late String district;
  late String state;
  late String dob;

//get adhar verification function to get adhar details of the candidate
  Future<void> getAdharVerified(String adharnum) async {
    try {
      final DocumentSnapshot adhars = await FirebaseFirestore.instance
          .collection('Adhars')
          .doc(adharnum)
          .get();
      if (adhars.data() != null) {

        _adharage = adhars.get('age'); //assign adhars age to adharage
        _adharnum = adhars.get('adharnum'); //store adharnum in this variablee
        name = adhars.get('name');
        address = adhars.get('address');
        district = adhars.get('district');
        state = adhars.get('state');
        email = adhars.get('email');
        mobile = adhars.get('mobileNum');
        dob = adhars.get('dob');
        if(!mounted)return;
        snackbarshow().showSnackBar(snackbarshow().succesAdharSnack, context); //show snackbar
      }
    } catch (e) {
      if (kDebugMode) {
        print('get adhar verified failed ::::: $e');
      }
      snackbarshow().showSnackBar(snackbarshow().errorAdharSnack, context);
    }
  }
  final formKey = GlobalKey<FormState>();

  TextEditingController candidateNameController = TextEditingController();
  TextEditingController candidateAdharController = TextEditingController();
  TextEditingController adminmtmskController = TextEditingController();
  TextEditingController selectpartycontroller = TextEditingController();

  //to refresh to see added details
  void refresh() {
    setState(() {});
  }

  late int numberOfCandidates;
  late File? filetodisplay;
  late bool isselected = false;
  late bool isloading = false;
  UploadTask? uploadTask;


  @override
  Widget build(BuildContext context) {
    if(isloading == false){
      return Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(onPressed: () {
                signOut();
              }, icon: const Icon(Icons.logout_sharp),),
              title: const Text('Add Candidate',style: TextStyle(color: Colors.white),),
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
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.image,
                                    allowMultiple: false,
                                  );

                                  if (result != null) {
                                    PlatformFile file = result.files.first;
                                    filetodisplay = File(file.path.toString());
                                    //String filename = file.name.toString();
                                    isselected=true;
                                    refresh();

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
                                },
                                child: SizedBox(height:100 ,width: 100,
                                  child: ClipRRect(borderRadius:BorderRadius.circular(100),child:Image(image:isselected?Image.file(filetodisplay!).image:
                                  const AssetImage('assets/undraw/electionday.png'),fit:BoxFit.fill,),),
                                ),
                              ),
                              const SizedBox(height: 8,),
                              const Text('Picture of candidate',style: TextStyle(fontSize:16,color: Colors.white),),
                              const SizedBox(height: 8,),
                              Container(padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null||value.isEmpty){
                                      return 'please enter the details';
                                    }
                                    return null;
                                  },
                                  controller: candidateNameController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(color: Colors.white),
                                      hintText: 'Enter Candidate Name',border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)))
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              Container(padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null||value.isEmpty){
                                      return 'please enter the details';
                                    }
                                    return null;
                                  },
                                  controller: candidateAdharController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(color: Colors.white),
                                      hintText: 'Enter Candidate Adhar Num',border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)))
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4,),
                              const SizedBox(height: 8,),
                              ListPickerField(label:'party of candidate',
                                items:party,controller:selectpartycontroller,),
                              const SizedBox(height: 8,),
                              Container(padding: const EdgeInsets.all(16),
                                child: TextFormField(
                                  validator: (value){
                                    if(value == null||value.isEmpty){
                                      return 'please enter the details';
                                    }
                                    return null;
                                  },
                                  controller: adminmtmskController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(color: Colors.white),
                                      hintText: 'Enter admins metamask private key',border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8)))
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24,),
                              const SizedBox(height: 4,),
                              ElevatedButton(
                                  onPressed: () async {
                                    setState(() {isloading = true;});
                                    if (formKey.currentState!.validate()&&filetodisplay!=null){
                                      await getAdharVerified(candidateAdharController.text);
                                      if (_adharage >= 18) {
                                        try{
                                          await uploadimageAndData().then((value) => {
                                            addCandidate(candidateNameController.text, widget.ethClient,
                                                adminmtmskController.text, widget.electionAdress),
                                          });
                                        }catch(e){
                                          if(!mounted)return;
                                          snackbarshow().showSnackBar(snackbarshow().errorAdharSnack, context);
                                        }
                                        gotoHome();
                                      } else {
                                        if(!mounted)return;
                                        snackbarshow().showSnackBar(snackbarshow().errorAdharSnack, context);
                                      }
                                    } else {
                                      if(!mounted)return;
                                      snackbarshow().showSnackBar(snackbarshow().errorSnack, context);
                                    }
                                    setState(() {isloading = false;});
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                  child: const Text('Add Candidate',style: TextStyle(color: Colors.purple),))
                            ],
                          ),
                        ),
                      ),
                      const Divider(thickness: 2,color: Colors.purple,),
                      Container(margin: const EdgeInsets.only(bottom: 56,left:8,),
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
                                              if (kDebugMode) {
                                                print(candidatesnapshot.data);
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
                                                  title: Text('Name: ${candidatesnapshot.data![0][0]}',
                                                    style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold),),
                                                  subtitle: Text('Votes: ${candidatesnapshot.data![0][1]}',
                                                    style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold),),
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
                    ],
                  ),
                ),
              ],
            )
        ),
      );
    }else{
      return Container(
          decoration:  const BoxDecoration(gradient:
          LinearGradient(colors: [
          Color(0xFF516395),
            Color(0xFF614385 ),])),
        child: Scaffold(
          appBar:AppBar(backgroundColor: Colors.transparent,elevation: 0,),
          body: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      );
    }
  }
  Future<void> uploadimageAndData() async{
    //file path and reference to storage
    final String filepath = 'electionimages/${widget.electionName}/partyimages/candidates/${candidateNameController.text.toString()}/';
    final storageref = FirebaseStorage.instance.ref().child(filepath);
    //reference to add data to collection
    final DocumentReference candidate = FirebaseFirestore.instance.collection('Election').doc(widget.electionName)
        .collection('candidates').doc(candidateAdharController.text.toString());
      try{
        //uploading picture
      uploadTask = storageref.putFile(filetodisplay!) ;
      //final snapshot = await uploadTask?.whenComplete((){});
      //uploading data
      await candidate.set({
        "Name":candidateNameController.text.toString(),"Age":_adharage,"adharnum":candidateAdharController.text.toString(),
        "party":selectpartycontroller.text.toString(),"email":email,
        "phonenum":mobile,"district":district,"state":state,"address":address,"dob":dob,
      });
      //clearing controllers
      if (kDebugMode) {
        print('succcessssssssssss');
      }
    }catch(e){
        if (kDebugMode) {
          print('whaat went wronggg :::: $e');
        }
      }
  }

  // Widget buildProgress() =>StreamBuilder<TaskSnapshot>(
  //     stream: uploadTask?.snapshotEvents,
  //     builder:(context , snapshot){
  //       if(snapshot.hasData){
  //         final data = snapshot.data;
  //         double progress = data!.bytesTransferred/data.totalBytes;
  //         return SizedBox(height: 50,
  //           child: Stack(
  //           fit: StackFit.expand,
  //             children: [
  //               LinearProgressIndicator(value: progress,backgroundColor: Colors.white,color: Colors.cyan,),
  //               Center(
  //                 child: Text('${(100 * progress).roundToDouble()}%',
  //                   style:const TextStyle(color: Colors.grey) ,),
  //               ),
  //             ],
  //         ),);
  //       }else{
  //         return const SizedBox(height: 50,);
  //       }
  //     }
  // );

  void gotoHome(){
    setState(() {isloading = false;});
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>
        DashBoard(ethClient:widget.ethClient, electionName:widget.electionName, electionaddress:widget.electionAdress)), (route) => false);
  }
}
