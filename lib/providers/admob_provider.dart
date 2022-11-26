import 'dart:io';

class AdmobProvider{
  static String? getBannerAdUnitId(){
    if(Platform.isAndroid){
      return "ca-app-pub-9190785688707604/8945980983";
    }else if(Platform.isIOS){
      return "ca-app-pub-3940256099942544/2934735716";
    }else{
      return null;
    }
  }
  static String? getinterAdUnitId(){
    if(Platform.isAndroid){
      return "ca-app-pub-9190785688707604/2776992606";
    }else if(Platform.isIOS){
      return "ca-app-pub-3940256099942544/4411468910";
    }else{
      return null;
    }
  }


}