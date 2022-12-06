import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:simple_video_editor/constants.dart';
import 'package:simple_video_editor/screens/homepage.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Video Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home:  Homepage(),
    );
  }
}
