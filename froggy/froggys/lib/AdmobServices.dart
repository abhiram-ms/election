
import 'dart:io';

class AdMobServices{

  static String? get rewardAdunitId{
    if(Platform.isAndroid){
      return 'ca-app-pub-4990232147628609/5333542563';
    }else if(Platform.isIOS){
      return 'ca-app-pub-4990232147628609/5333542563';
    }return null;
  }

}