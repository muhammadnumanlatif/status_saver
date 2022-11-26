import 'package:flutter/material.dart';
import 'package:status_saver/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }
  void navigate(){
    Future.delayed(Duration(seconds: 2),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MainScreen()), (route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset("assets/splash.png"),
      ),
    );
  }
}
