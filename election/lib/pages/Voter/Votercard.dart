import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';

import '../../State/VotercardController.dart';
import '../../Widgets/WidgetBuilds.dart';
import '../../services/Auth.dart';
import '../../services/IntoLogin.dart';

class Votercard extends StatelessWidget {
  final Web3Client? ethClient;
  final String? electionName;
  final String? electionaddress;
  final Map<String,dynamic>?  votermap;
  const Votercard({Key? key,required this.ethClient, required this.electionName,required this.electionaddress,required this.votermap}) : super(key: key);

  Future<void>signOut()async{
    await Auth().signOut();
    Get.offAll(IntroLogin());
  }
  
  @override
  Widget build(BuildContext context) {
    VoterCardController cardController = Get.put(VoterCardController(electionName!,votermap));
    if(cardController.isAuth == true){
      return Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: Scaffold(
          appBar: AppBar(
            title: Text('$electionName'),
            leading: IconButton(onPressed: () {signOut();}, icon: const Icon(Icons.logout),),
            // actions: [IconButton(onPressed:(){}, icon: const Icon(Icons.refresh))],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(12),
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 4,
                borderOnForeground: true,
                child:cardBuild(context,votermap) ,
              ),
            ),
          ),
        ),
      );

    }else{
      return SuperWidgets().authorisedAlready(context);
    }
  }

  Widget cardBuild(BuildContext context, Map<String,dynamic>? votermap,)=>Container(
    child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(margin: const EdgeInsets.all(8),
          child: Card(elevation: 4,borderOnForeground: true,
            child: Container(height: 100,width: 100,margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: const DecorationImage(
                        image: AssetImage('assets/undraw/appreciation.png')))),
          ),
        ),
        Row(
          children: [
            Container(padding:const EdgeInsets.all(8),margin: const EdgeInsets.all(4),
              child: Text('Name : ${votermap!['name']}',style: const TextStyle(
                  fontWeight: FontWeight.bold,fontSize:16,color: Colors.black)),
            ),
            Container(padding:const EdgeInsets.all(8),margin: const EdgeInsets.all(4),
              child: Text('State : ${votermap['state']}',style: const TextStyle(
                  fontWeight: FontWeight.bold,fontSize:16,color: Colors.black)),
            )
          ],
        ),
        Container(padding:const EdgeInsets.all(8),margin: const EdgeInsets.all(4),
          child: Text('Phone no : : ${votermap['phone']}',style: const TextStyle(
              fontWeight: FontWeight.bold,fontSize:16,color: Colors.black)),
        ),
        Container(padding:const EdgeInsets.all(8),margin: const EdgeInsets.all(4),
          child: Text('Adhar number : ${votermap['adharnum']}',style: const TextStyle(
              fontWeight: FontWeight.bold,fontSize:16,color: Colors.black)),
        ),
        Container(padding:const EdgeInsets.all(8),margin: const EdgeInsets.all(4),
          child: Text('Email id : ${votermap['email']}',style: const TextStyle(
              fontWeight: FontWeight.bold,fontSize:16,color: Colors.black)),
        ),
        const SizedBox(height: 16,),
        Container(padding:const EdgeInsets.all(8),margin: const EdgeInsets.all(4),
          child: const Text('Election details',style: TextStyle(
              fontWeight: FontWeight.bold,fontSize:16,color: Colors.black)),
        ),
        const Divider(thickness: 2,color: Colors.black,),
        const SizedBox(height: 16,),
        Container(padding:const EdgeInsets.all(8),margin: const EdgeInsets.all(4),
          child: Text('Election Name : $electionName',style: const TextStyle(
              fontWeight: FontWeight.bold,fontSize:16,color: Colors.black)),
        )
      ],
    ),
  );

}
