import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:froggys/AdmobServices.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int froggy = 0;
  late RewardedAd? _rewardedAd;

  @override
  void initState() {
    _createRewardedAd();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(margin: const EdgeInsets.only(top: 40),
        child: Center(
          child: Column(
            children: [
              Text("the froggy score is $froggy"),
              ElevatedButton(onPressed: (){
                _showRewardedAd();
               }, child:const Text('show ad'))
            ],
          ),
        ),
      ),
    );
  }

  void _createRewardedAd(){
    RewardedAd.load(
        adUnitId: AdMobServices.rewardAdunitId!,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad)=>setState(() {
              _rewardedAd = ad;
            }), onAdFailedToLoad: (err)=>setState(() {
              _rewardedAd = null;
            }),
        ));

  }

  void _showRewardedAd(){
    if(_rewardedAd != null){
      _rewardedAd!.fullScreenContentCallback =  FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          ad.dispose();
          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad,err){
          ad.dispose();
          _createRewardedAd();
      }
      );
      _rewardedAd!.show(onUserEarnedReward:(ad,reward)=>setState(() {
        froggy++;
      }));
    }
  }
}
