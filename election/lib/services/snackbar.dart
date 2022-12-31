
import 'package:flutter/material.dart';

class snackbarshow {
  SnackBar errorAdharSnack = const SnackBar(content: Text('Adhar verification failed make sure details are right'));
  SnackBar succesAdharSnack = const SnackBar(content: Text('Adhar verification successfull'));
  SnackBar errorSnack = const SnackBar(content: Text('Fill all the details'));
  SnackBar errorSnackinternet = const SnackBar(content: Text('sorry interruption problem from server '));

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(SnackBar snackBar,BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}