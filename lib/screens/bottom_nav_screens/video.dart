import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:status_saver/providers/getStatusProvider.dart';
import 'package:status_saver/screens/bottom_nav_screens/image_view.dart';
import 'package:status_saver/screens/main_screen.dart';
import 'package:status_saver/utils/get_thumbnail.dart';
import '../../providers/admob_provider.dart';
import '../../providers/getStatusProvider.dart';
import 'video_view.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {


  bool _isFetched=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<GetStatusProvider>(
            builder: (context,file,child) {
              if(_isFetched==false){
                file.getStatus(".mp4");
                Future.delayed(Duration(seconds:3),() {
                  _isFetched=true;
                },);
              }
              return file.isWhatsappAvailable==false
                  ? Center(child: Text("No Whatsapp available..."))
                  : file.getVideos.isEmpty?Center(child: Text("No Videos found...")):Container(
                padding: EdgeInsets.all(20),
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  children: List.generate(file.getVideos.length, (index) {
                    final data = file.getVideos[index];
                    return FutureBuilder(
                      future: getThumbnail(data.path),
                      builder: (context,snapshot) {
                        if(!snapshot.hasData){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoView(path: file.getVideos[index].path,)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                  image: FileImage(File(snapshot.data!))
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  }),
                ),
              );}
        ));
  }
}
