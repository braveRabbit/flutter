import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_video_editor/constants.dart';
import 'package:simple_video_editor/screens/editor_screen.dart';
import 'package:simple_video_editor/screens/video_picker.dart';
import 'package:flutter/foundation.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () async {
            await _picker.pickVideo(source: ImageSource.gallery).then((value) {
              debugPrint(value?.path.toString());
              if (value?.path == null) {
                Get.snackbar("select video", "Please select video");
              } else {
                Get.to(() => EditorScreen(
                      videoPath: File(value!.path),
                    ));
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [kPrimaryColor, Colors.green[300]!]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Select Video',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
