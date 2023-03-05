import 'package:election/State/homeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

class CloseElec extends StatelessWidget {
  final Web3Client ethClient;
  final String electionName;
  final String electionAdress;
    CloseElec({Key? key, required this.ethClient, required this.electionName, required this.electionAdress}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController adharNumberController = TextEditingController();
  final TextEditingController electionIdController = TextEditingController();
  final TextEditingController adminMetamaskController = TextEditingController();
  //final TextEditingController selectpartycontroller = TextEditingController();



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
          child: Form(
            key:formKey,
            child: Column(
              children: [
                Container(padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if(value == null||value.isEmpty){
                        return 'please enter the details';
                      }
                      return null;
                    },
                    controller: adharNumberController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter Admin Aadhaar number ',border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8)))
                    ),
                  ),
                ),
                Container(padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if(value == null||value.isEmpty){
                        return 'please enter the details';
                      }
                      return null;
                    },
                    controller: adharNumberController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter Admin Aadhaar number ',border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8)))
                    ),
                  ),
                ),
                Container(padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if(value == null||value.isEmpty){
                        return 'please enter the details';
                      }
                      return null;
                    },
                    controller: adharNumberController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter Admin Aadhaar number ',border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8)))
                    ),
                  ),
                ),
                Container(padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if(value == null||value.isEmpty){
                        return 'please enter the details';
                      }
                      return null;
                    },
                    controller: adharNumberController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter Admin Aadhaar number ',border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8)))
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: ElevatedButton(style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
                      onPressed: (){

                   }, child: const Text('Close election',style: TextStyle(color: Colors.purple),)),
                ),
                const Divider(color: Colors.white,),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(8),
                  child: const Text('* closing  election forcefully will lead to inaccurate election results the election '
                      'will be automatically closed after a certain period of time',style: TextStyle(color: Colors.white,fontSize: 16),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
