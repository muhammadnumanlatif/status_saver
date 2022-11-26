import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_api/flutter_native_api.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:status_saver/utils/extensions.dart';

import '../../providers/admob_provider.dart';



class VideoView extends StatefulWidget {
   VideoView({Key? key, required this.path}) : super(key: key);
final String path;

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  List<Widget> buttonList=[
    Icon(Icons.download),
    Icon(Icons.share),

  ];
  static const int maxFailedLoadAttempts = 5;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  VlcPlayerController? _videoPlayerController;

  Future<void> initializePlayer() async {}

  @override
  void initState() {

    super.initState();
    _createInterstitialAd();
    _videoPlayerController = VlcPlayerController.file(
      File(widget.path),
      hwAcc: HwAcc.decoding,
      autoPlay: true,

      options: VlcPlayerOptions(),
    );
    print(widget.path);
  }

  @override
  void dispose() async{


    super.dispose();
    await _videoPlayerController!.stopRendererScanning();
    await _videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
body:Column(
  children: [
    SizedBox(
      height: 100,
      width: double.infinity,
      child: AdWidget(
        ad: BannerAd(
          adUnitId: AdmobProvider.getBannerAdUnitId()!,
          //adUnitId: "ca-app-pub-3940256099942544/6300978111",
          size: AdSize.largeBanner,
          request: AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (Ad ad) =>print("Ad loaded"),
            onAdFailedToLoad: (Ad ad, LoadAdError error){
              ad.dispose();
              print("Ad failed to load: $error");
            },
            onAdOpened: (Ad ad)=>print("Ad opened"),
            onAdClosed: (Ad ad)=>print("Ad closed"),
          ),
        )..load(),
      ),
    ),
        Expanded(
          child: VlcPlayer(

            controller: _videoPlayerController!,

            aspectRatio: 16 / 9,

            placeholder: Center(child: CircularProgressIndicator()),

          ),
        ),
  ],
),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(left: 10.0.wp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(buttonList.length, (index){
              return FloatingActionButton(
                heroTag: "$index",
                onPressed: (){
                  switch(index){
                    case 0:
                      _showInterstitialAd();
                      ImageGallerySaver.saveFile(widget.path!).then((value){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Video Saved")));
                      });
                      break;
                    case 1:
                      _showInterstitialAd();
                      FlutterNativeApi.shareImage(widget.path!);
                      break;
                  }
                },
                child: buttonList[index],
              );
            })
            ,
          ),
        )
    );
  }
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdmobProvider.getinterAdUnitId()!,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
