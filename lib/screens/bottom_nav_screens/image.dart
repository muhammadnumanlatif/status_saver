import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:status_saver/providers/getStatusProvider.dart';
import 'package:status_saver/screens/bottom_nav_screens/image_view.dart';
import 'package:status_saver/screens/main_screen.dart';
import 'package:status_saver/utils/extensions.dart';
import '../../providers/admob_provider.dart';
import '../../providers/getStatusProvider.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {


bool _isFetched=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<GetStatusProvider>(
        builder: (context,file,child) {
          if(_isFetched==false){
            file.getStatus(".jpg");
            Future.delayed(Duration(seconds:3),() {
              _isFetched=true;
            },);
          }
        return file.isWhatsappAvailable==false
            ? Center(child: Text("No Whatsapp available..."))
            : file.getImages.isEmpty?Center(child: Text("No Images found...")):Container(
            padding: EdgeInsets.all(10.0.wp),
            child: Column(
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
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    children: List.generate(file.getImages.length, (index) {
                      final data = file.getImages[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageView(imagePath: data.path,)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(data.path))
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );}
        ));
  }
}
