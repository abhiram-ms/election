import 'package:election/State/homeController.dart';
import 'package:election/pages/Admin/AdminHome.dart';
import 'package:election/pages/Admin/DashBoard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/Constants.dart';
import 'functions.dart';

class Pickelec extends StatelessWidget {
  final bool admin;
  const Pickelec({Key? key, required this.admin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    //if he is admin continue
    if (admin == true) {
      return Container(//for the background
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385),
        ])),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                homeController.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    //
                  },
                  icon: const Icon(Icons.refresh)),
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>   AdminHome()));
                  },
                  icon: const Icon(Icons.how_to_vote))
            ],
            title: const Text('Admin Pick Election'),
            backgroundColor: Colors.transparent,
          ),
          body: SingleChildScrollView(
            child: Column(        //colum contains all elements
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 56),
                  child: SingleChildScrollView(
                    child: FutureBuilder<List>(
                      future: getElectionsList(homeController.ethclient!,contractAdressConst),
                        builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Center(child: CircularProgressIndicator());
                        }else if(snapshot.hasError){
                          Get.snackbar('Error ','cannot fetch data at the moment');
                          return const Center(child: Text('Error : Cannot fetch data at the moment',style: TextStyle(color: Colors.white),));
                        } else if(snapshot.hasData){
                          if(snapshot.data!.isEmpty){
                            return const Center(child: Text('There is no election at the moment',style: TextStyle(color: Colors.white),));
                          }else{
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                  itemCount: snapshot.data![0][0].length,
                                  itemBuilder: (context,index){
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
                                          Get.offAll(()=>DashBoard(
                                              ethClient:homeController.ethclient!,
                                              electionName: snapshot.data![0][index][0],
                                              electionaddress: snapshot.data![0][index][1].toString()));
                                        },
                                        title: Text('${snapshot.data![0][index][0]}', style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold),),
                                        subtitle: Text('election $index'),
                                        trailing: const Icon(Icons.poll_outlined),
                                      ),
                                    );
                                  }),
                            );
                          }
                        }else{
                          Get.snackbar('Error ','cannot fetch data at the moment');
                          return  const Center(child: Text('Cannot fetch data at the moment',style: TextStyle(color: Colors.white),));
                        }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration:  const BoxDecoration(gradient:
        LinearGradient(colors: [
          Color(0xFF516395),
          Color(0xFF614385 ),
        ])),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                homeController.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    //
                  },
                  icon: const Icon(Icons.refresh))
            ],
            title: const Text('Voter Pick Election'),
            backgroundColor: Colors.transparent,
          ),
          body:  Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 56),
                      child: SingleChildScrollView(
                        child:FutureBuilder<List<dynamic>>(
                            future: getElectionsList(homeController.ethclient!,contractAdressConst),
                            builder: (context, snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const CircularProgressIndicator();
                              }else if(snapshot.hasError){
                                Get.snackbar('Error ','cannot fetch data at the moment');
                                return const Text('Error : Cannot fetch data at the moment',style: TextStyle(color: Colors.white),);
                              } else if(snapshot.hasData){
                                if(snapshot.data!.isEmpty){
                                  return const Text('There is no election at the moment',style: TextStyle(color: Colors.white),);
                                }else{
                                  return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context,index){
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
                                          //    Get.offAll(()=>VoterHome(ethClient: ethClient, electionName: electionName, electionaddress: electionaddress, electiondata: electiondata));
                                            },
                                            title: Text('${snapshot.data![index][0]}', style: const TextStyle(fontSize:16,fontWeight:FontWeight.bold),),
                                            subtitle: Text('election $index'),
                                            trailing: const Icon(Icons.poll_outlined),
                                          ),
                                        );
                                      });
                                }
                              }else{
                                Get.snackbar('Error ','cannot fetch data at the moment');
                                return  const Text('Cannot fetch data at the moment',style: TextStyle(color: Colors.white),);
                              }
                            })
                      ),
                    ),
                  ],
                ),
              ),
              GetBuilder<HomeController>(builder: (_){
                if (homeController.isFetching == true) {
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
  }
}
