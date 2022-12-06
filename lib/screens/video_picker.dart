import 'package:flutter/material.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:get/route_manager.dart';
import 'package:simple_video_editor/constants.dart';
import 'package:simple_video_editor/screens/editor_screen.dart';

class VideoPickerScreen extends StatelessWidget {
  const VideoPickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GalleryMediaPicker(
        appBarColor: kPrimaryColor,
        onlyVideos: true,
        appBarIconColor: Colors.white,
        singlePick: true,
        pathList: (val) {
          Get.to(() => EditorScreen(
                videoPath: val.first.file!,
              ));
        },
      ),
    );
  }
}
