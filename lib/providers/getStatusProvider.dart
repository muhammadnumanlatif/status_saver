import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:status_saver/utils/constants.dart';

class GetStatusProvider extends ChangeNotifier{
  List<FileSystemEntity> _getVideos=[];
  List<FileSystemEntity> _getImages=[];
  final Directory _videoDir = Directory(
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');

  List<FileSystemEntity> get getImages=>_getImages;
  List<FileSystemEntity> get getVideos=>_getVideos;

  bool _isWhatsappAvailable =  false;

  bool get isWhatsappAvailable=>_isWhatsappAvailable;


  void getStatus(String ext) async{
    final status = await Permission.storage.request();
   // //Directory? directory = await getExternalStorageDirectory();
   //
      if(status.isDenied){
        Permission.storage.request();
        print("Permmision Denied");
        return;
      }

    if(status.isGranted){
      //rint(directory!.path);
      //1final directory=Directory();
      if(Directory('${_videoDir.path}').existsSync()){
        final items = _videoDir.listSync();

        if(ext==".mp4"){
          // items.map((item) => item.path)
          //     .where((item) {
          //      return item.endsWith(ext);
          //     })
          //     .toList(growable: false);
          _getVideos=items.where((element) => element.path.endsWith(ext)).toList();



          notifyListeners();
        }else{
          // items.map((item) => item.path)
          //     .where((item) => item.endsWith(ext))
          //     .toList(growable: false);
        _getImages=  items.where((element) => element.path.endsWith(ext)).toList();

          notifyListeners();
        }

        _isWhatsappAvailable=true;
        notifyListeners();

        print(items.toString());
      }else{
        print("Not whatsapp found");
        _isWhatsappAvailable=false;
        notifyListeners();
      }
    }

  }
}