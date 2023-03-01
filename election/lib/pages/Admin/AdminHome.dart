import 'package:election/State/homeController.dart';
import 'package:election/pages/Admin/AdminRegister.dart';
import 'package:election/services/IntoLogin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/Auth.dart';
import '../../services/VerifyEmail.dart';

class AdminHome extends StatelessWidget {
   AdminHome({Key? key}) : super(key: key);

  Future<void> signOut() async {
    await Auth().signOut();
    Get.offAll(()=> const IntroLogin());
  }

  final TextEditingController adharTextController = TextEditingController();
  final TextEditingController electionNameTextController = TextEditingController();
  final TextEditingController privateKeyTextController = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController dateinput = TextEditingController();
  final TextEditingController dateinputend = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
      if (homeController.currentuser!.emailVerified) {
        if (homeController.isTrue == true) {
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFF516395),
              Color(0xFF614385),
            ])),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    signOut();
                  },
                  icon: const Icon(Icons.logout),
                ),
                title: const Text('ADMIN DASHBOARD'),
                backgroundColor: Colors.transparent,
                actions:  <Widget>[
                  IconButton(
                      onPressed: () {
                        homeController.update();
                      },
                      icon: const Icon(Icons.refresh))
                ],
              ),
              body: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formkey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            const Center(
                                child: SelectableText(
                                    "f6468ec22fe10152849e4301db68f056933c5367832fa4dcd97e1e5a808834f3")),
                            UserTextInput(controller: electionNameTextController,hinttext: 'Election Name',),
                            UserTextInput(controller: adharTextController,hinttext: 'Adhar Number',),
                            UserTextInput(controller: privateKeyTextController,hinttext: 'Metamask Private Key',),
                            UserTextInput(controller: state,hinttext: 'Enter the state to conduct election',),
                            UserTextInput(controller: district,hinttext: 'Enter district to conduct election',),
                            Container(
                              height: MediaQuery.of(context).size.width / 3,
                              padding: const EdgeInsets.all(4),
                              child: TextField(
                                controller: dateinput,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                                readOnly: true,
                                decoration: const InputDecoration(
                                    labelText: 'Start date ',
                                    icon: Icon(
                                      Icons.calendar_month_sharp,
                                      color: Colors.white,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white)),
                                onTap: () async {
                                  homeController.getDate(context, dateinput);
                                },
                              ),
                            ),
                            const SizedBox(height: 8,),
                            Container(
                              height: MediaQuery.of(context).size.width / 3,
                              padding: const EdgeInsets.all(4),
                              child: TextField(
                                controller: dateinputend,
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.white),
                                readOnly: true,
                                decoration: const InputDecoration(
                                    labelText: 'End date ',
                                    icon: Icon(
                                      Icons.calendar_month_sharp,
                                      color: Colors.white,
                                    ),
                                    labelStyle: TextStyle(color: Colors.white)),
                                onTap: () async {
                                  homeController.getEndDate(context, dateinputend);
                                },
                              ),
                            ),
                            const SizedBox(height: 8,),
                            ElevatedButton(
                                onPressed: () {
                                  final FormState? form = formkey.currentState;
                                  if(form != null){
                                    if(form.validate()){
                                      try {
                                        homeController.startElectionComplete(adharTextController.text,electionNameTextController.text,
                                            state.text,district.text, privateKeyTextController.text);
                                      } catch (e) {
                                        if (kDebugMode) {
                                          print('this is the reason $e');
                                        }
                                      }
                                    }else{
                                      Get.snackbar('fill details', 'fill all details first');
                                    }
                                  }else{
                                    Get.snackbar('fill details', 'fill all details first');
                                  }
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                                child: const Text(
                                  'Start Election',
                                  style: TextStyle(color: Colors.purple),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  GetBuilder<HomeController>(builder: (_){
                    if (homeController.isLoading == true) {
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
              ),
            ),
          );
        } else {
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xFF516395),
              Color(0xFF614385),
            ])),
            child: Scaffold(
              appBar: AppBar(
                title: const Text('verify email'),
                backgroundColor: Colors.transparent,
              ),
              body: Center(
                child: Column(
                  children: const [
                    Text('Loading ... If you are a voter Login as a voter'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        }
      } else {
        return Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xFF516395),
            Color(0xFF614385),
          ])),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('verify email'),
              backgroundColor: Colors.transparent,
            ),
            body: Center(
              child: Column(
                children: [
                  Text('Your Email ${homeController.usernow.email} is not verified'),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VerifyEmail()),
                            (route) => false);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      child: const Text('Verify Email'))
                ],
              ),
            ),
          ),
        );
      }
  }
}
