import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../State/auth_controller.dart';
import 'VoterRegister.dart';

class VoterLogin extends StatelessWidget {
   VoterLogin({Key? key}) : super(key: key);

  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    return Container(
      decoration:  const BoxDecoration(gradient:
      LinearGradient(colors: [
        Color(0xFF516395),
        Color(0xFF614385 ),
      ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text(
            "Login Admin",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              color: Colors.transparent,
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                              controller: _controlleremail,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8))))),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: TextField(

                              controller: _controllerpassword,
                              decoration: const InputDecoration(
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: 'password',
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8))))),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_controllerpassword.text.isNotEmpty &&
                                _controlleremail.text.isNotEmpty) {
                              await signInWithEmailAndPassword(authController);
                            }else{
                              Get.snackbar('Fill details', 'The details are not filled');
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: const Text(
                            'Login as Voter',
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VoterRegister()));
                              },
                              child: const Text(
                                  'Not Registered ?? Click to Register',
                                  style: TextStyle(color: Colors.white))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            GetBuilder<AuthController>(builder: (_){
              if (authController.isloading == true) {
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
          ],
        ),
      ),
    );
    }

   Future<void> signInWithEmailAndPassword(AuthController authController) async {
     try {
       String email = _controlleremail.text.toString();
       String password = _controllerpassword.text.toString();
       authController.signInWithEmailAndPassword(email, password,false);
     }catch (e) {
       Get.snackbar('','error occurred : $e');
     }
   }


}
