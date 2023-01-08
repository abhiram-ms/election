
import 'package:flutter/material.dart';

class snackbarshow {
  SnackBar errorAdharSnack = const SnackBar(content: Text('Adhar verification failed make sure details are right'));
  SnackBar succesAdharSnack = const SnackBar(content: Text('Adhar verification successfull'));
  SnackBar errorSnack = const SnackBar(content: Text('Fill all the details'));
  SnackBar errorSnackinternet = const SnackBar(content: Text('sorry interruption problem from server '));

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar,BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  SnackBar errorStartelection = const SnackBar(content: Text('There was an error from our side we are sorry'));

  SnackBar errorstate = const SnackBar(content: Text('This election doesnt fit your state'));
  SnackBar endedelection = const SnackBar(content: Text('cannot acess the election it may be ended'));
}

class Loadingbar {

  Widget loadbarfunction(){
    return Container(
      decoration:  const BoxDecoration(gradient:
      LinearGradient(colors: [
        Color(0xFF516395),
        Color(0xFF614385 ),
      ])),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

}