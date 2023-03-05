
import 'package:election/State/homeController.dart';
import 'package:election/pages/Admin/DashBoard.dart';
import 'package:election/utils/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'package:list_picker/list_picker.dart';

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

  List<String> party = ['BJP','BSP','CPI','CPM','INC','NPC','Individual',];

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
  final formKey = GlobalKey<FormState>();

  TextEditingController candidateNameController = TextEditingController();
  TextEditingController candidateAdharController = TextEditingController();
  TextEditingController adminmtmskController = TextEditingController();
  TextEditingController selectpartycontroller = TextEditingController();

  //to refresh to see added details
  void refresh() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
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
                              GetBuilder<HomeController>(builder: (_)=>InkWell(
                                onTap: () async {
                                  homeController.pickCandidatePhoto();
                                },
                                child: SizedBox(height:100 ,width: 100,
                                  child: ClipRRect(borderRadius:BorderRadius.circular(100),
                                    child:Image(image:homeController.isselected?Image.file(homeController.filetodisplay!).image:
                                    const AssetImage('assets/undraw/electionday.png'),fit:BoxFit.fill,),),
                                ),
                              ),),
                              const SizedBox(height: 8,),
                              const Text('Picture of candidate',style: TextStyle(fontSize:16,color: Colors.white),),
                              const SizedBox(height: 8,),
                              Container(padding: const EdgeInsets.all(8),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    if (formKey.currentState!.validate()&&homeController.filetodisplay!=null){
                                      //try and catch for functions
                                      try{

                                        // getting adhar verified and adding candidate data
                                        await homeController.getAdharVerifiedCandidate(candidateAdharController.text);
                                        if (homeController.adharAge >= 18) {
                                          toAddCandidate(homeController);
                                          gotoHome();
                                        } else {
                                          Get.snackbar('Error', 'Adhar Verification failed :( ');
                                        }

                                      }catch(e){
                                        Get.snackbar('Error', 'Adhar Verification failed :( ');
                                      }
                                    } else {
                                      Get.snackbar('Fill all details ', 'add picture and data of candidate');
                                    }
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
                          child: StreamBuilder<List>(stream: getCandidatesInfoList(
                              widget.ethClient, widget.electionAdress).asStream(),
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
                                  return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data![0].length,
                                      itemBuilder: (context,index){
                                        if (kDebugMode) {
                                          print('....index: ${snapshot.data}');
                                        }
                                        if (kDebugMode) {
                                          print('....index: $index}');
                                        }

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
                                      });
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
                GetBuilder<HomeController>(builder: (_){
                  if (homeController.isloading == true) {
                    return Container(
                      color: Colors.white.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(backgroundColor: Colors.redAccent,color: Colors.white,),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                GetBuilder<HomeController>(builder: (_){
                  if (homeController.isaAdharVerifying == true) {
                    return Container(
                      color: Colors.purpleAccent.withOpacity(0.5),
                      child:  Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height/2,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.asset('assets/undraw/noted.png'),
                                ),
                                const Expanded(child: Text('verifying aadhaar',style: TextStyle(color: Colors.white),),),
                                const CircularProgressIndicator(),
                              ],
                            ),
                          )
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ],
            )
        ),
      );
  }

  void gotoHome(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>
        DashBoard(ethClient:widget.ethClient, electionName:widget.electionName, electionaddress:widget.electionAdress)), (route) => false);
  }

  void toAddCandidate(HomeController homeController) {
    Map<String,dynamic> candidateData = {
      "Name":candidateNameController.text.toString(),"Age":homeController.adharAge,"adharnum":candidateAdharController.text.toString(),
      "party":selectpartycontroller.text.toString(),"email":homeController.email,
      "phonenum":homeController.mobile,"district":homeController.district,"state":homeController.state,
      "address":homeController.address,"dob":homeController.dob,
    };

    try{
      if (kDebugMode) {
        print(candidateData);
      }
      if(homeController.filetodisplay != null){
        homeController.addCandidateAndUpload(candidateData, widget.electionName, widget.electionAdress,adminmtmskController.text);
      }else{
        Get.snackbar("candidate photo needed ", "add a photo of candidate");
      }
    }catch(e){
      Get.snackbar('error','failed to do the action');
      if (kDebugMode) {
        print("this is toAddCandidate error $e");
      }
    }

  }
}
