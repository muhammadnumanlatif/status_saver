import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:status_saver/providers/bottom_nav_provider.dart';
import 'package:status_saver/screens/bottom_nav_screens/image.dart';

import 'bottom_nav_screens/video.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> screens =[
    ImageScreen(),
    VideoScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context,nav, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: screens[nav.current],
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              nav.changeIndex(value);
            },
              currentIndex: nav.current,
            items:[
              BottomNavigationBarItem(icon: Icon(Icons.image),label: "Image"),
              BottomNavigationBarItem(icon: Icon(Icons.video_call),label: "Video"),

            ]
          ),
        );
      }
    );
  }
}
