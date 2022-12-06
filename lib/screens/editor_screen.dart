import 'dart:io';
import 'dart:math';

import 'package:export_video_frame/export_video_frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:interactive_box/interactive_box.dart';
import 'package:simple_video_editor/constants.dart';
import 'package:simple_video_editor/screens/thumbnail_preview.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:video_player/video_player.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:flutter/foundation.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key, required this.videoPath});
  final File videoPath;

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late VideoPlayerController _controller;
  final WidgetsToImageController _widgetsToImageController =
      WidgetsToImageController();
  @override
  void initState() {
    super.initState();

// file(widget.videoPath)
    print(widget.videoPath.path);
    _controller = VideoPlayerController.network('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  double getAspectRatio() {
    if (_controller.value.isInitialized) {
      if (_controller.value.aspectRatio > 1.6) {
        return 16 / 9;
      } else if (_controller.value.aspectRatio < 1.6 &&
          _controller.value.aspectRatio > 1.3) {
        return 4 / 3;
      } else if (_controller.value.aspectRatio < 1.3 &&
          _controller.value.aspectRatio > 0.5) {
        return 3 / 4;
      }
    }
    return 1;
  }

  Size getSize(BuildContext context) {
    double aspectRatio = getAspectRatio();
    final size = MediaQuery.of(context).size;

//Convert aspect ratio to width and height
    double width = size.width;
    double height = width / aspectRatio;

    if (height > size.height) {
      height = size.height;
      width = height * aspectRatio;
    }

    return Size(width, height);
  }

  double _scale = 1.0;
  double _previousScale = 1.0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Edit Video',
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.share,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Implement pinch to zoom and pinch out to zoom out
          WidgetsToImage(
            controller: _widgetsToImageController,
            child: Container(
              height: size.height * 0.6,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              color: Colors.grey[900],
              child: InteractiveBox(
                initialSize: getSize(context),
                initialRotateAngle: 0.0,
                includedActions: const [
                  ControlActionType.move,
                  ControlActionType.scale,
                ],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: GestureDetector(
                        onScaleStart: (ScaleStartDetails details) {
                          print(details);
                          _previousScale = _scale;
                          setState(() {});
                        },
                        onScaleUpdate: (ScaleUpdateDetails details) {
                          print(details);
                          _scale = _previousScale * details.scale;
                          setState(() {});
                        },
                        onScaleEnd: (ScaleEndDetails details) {
                          print(details);
                          _previousScale = 1.0;
                          setState(() {});
                        },
                        child: RotatedBox(
                          quarterTurns: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.diagonal3(
                                  Vector3(_scale, _scale, _scale)),
                              child: viewer(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              final file = await _widgetsToImageController.capture();
              var image = await ExportVideoFrame.exportImageBySeconds(
                  widget.videoPath, _controller.value.position, pi / 180);
              Get.to(() => ThumbnailPreview(
                    file: file!,
                    image: image,
                    video: widget.videoPath,
                  ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [kPrimaryColor, Colors.green[300]!]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Save Video',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Stack viewer() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: getAspectRatio(),
          child: VideoPlayer(_controller),
        ),
        Container(
            child: Text(
                "Total Duration:" + _controller.value.duration.toString())),
        Container(
            child: VideoProgressIndicator(_controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                    backgroundColor: Colors.redAccent,
                    playedColor: Colors.green,
                    bufferedColor: Colors.purple))),
        AspectRatio(
          aspectRatio: getAspectRatio(),
          child: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Icon(
                _controller.value.isPlaying
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_arrow_solid,
                color: Colors.white,
                size: 60,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
