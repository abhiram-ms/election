import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../State/auth_controller.dart';
import '../../utils/Constants.dart';
import '../Admin/AdminRegister.dart';

class VoterRegister extends StatelessWidget {
   VoterRegister({Key? key}) : super(key: key);

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controlleremail = TextEditingController();
  final TextEditingController _controllerphone = TextEditingController();
  final TextEditingController _controllerpassword = TextEditingController();
  final TextEditingController _controllerrepassword = TextEditingController();
  final TextEditingController _controlleradhar = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
          title: const Text(
            "Register as Admin",
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
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        UserTextInput(controller: _controllerName,hinttext: 'Name as in adhar *'),
                        UserTextInput(controller: _controlleremail,hinttext: 'Email of user *'),
                        UserTextInput(controller: _controllerphone,hinttext: 'Phone number as in adhar *',numberkeyboard: true,),
                        UserTextInput(controller: _controlleradhar,hinttext: 'Adhar Number*',numberkeyboard: true,),
                        UserTextInput(controller: _controllerpassword,hinttext: 'Password (8- characters) *',obscuretext: true,),
                        UserTextInput(controller: _controllerrepassword,hinttext: ' confirm your password*',obscuretext: true,),
                        ElevatedButton(
                          onPressed: () async {
                            final FormState? form = _formkey.currentState;
                            if(form != null){
                              if(form.validate()){
                                await addAndCreateUser(authController);
                              }else{
                                Get.snackbar('fill details', 'fill all details first');
                              }
                            }else{
                              Get.snackbar('fill details', 'fill all details first');
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: const Text(
                            'Register as Admin',
                            style: TextStyle(color: Colors.purple),
                          ),
                        )
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


   //cloud firestore using firestore
   Future<void>addAndCreateUser(AuthController authController)async{

     String name = _controllerName.text;
     String email=_controlleremail.text;
     String password=_controllerpassword.text;
     String phone=_controllerphone.text;
     String adhar = _controlleradhar.text;
     bool isTrue = false;

     Map<String,dynamic> userdata = {
       "Name":name,"e-mail":email,"password":password,"phone":phone,"Admin":isTrue,"adhar":adhar,
     };

     try{
       await authController.addUser(userdata,false);
       await authController.createUserWithEmailAndPassword(userdata,false);
       Userbox.write('userdata',userdata);
     }catch(e){
       if (kDebugMode) {
         print('to map error ::: $e');
       }
     }

     if (kDebugMode) {
       var userinfo =  Userbox.read('userdata');
       print(userinfo['e-mail']);
       print('this is data stored :::: ${Userbox.read('userlogindata')}');
       print('this is user data ::::${Userbox.read('userdata')}');
     }
   }

}
