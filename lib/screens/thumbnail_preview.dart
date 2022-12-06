import 'dart:io';

import 'package:cr_file_saver/file_saver.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class ThumbnailPreview extends StatefulWidget {
  const ThumbnailPreview({super.key, required this.file, required this.image, required this.video});
  final Uint8List file;
  final File image;
  final File video;

  @override
  State<ThumbnailPreview> createState() => _ThumbnailPreviewState();
}

class _ThumbnailPreviewState extends State<ThumbnailPreview> {
  final WidgetsToImageController _widgetsToImageController =
      WidgetsToImageController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Preview',
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.share,
            ),
            onPressed: () async {
              //Save file to gallery
              final captured = await _widgetsToImageController.capture();



              await FileSaver.instance.saveAs( "simpleEditerVideo",  widget.video.readAsBytesSync(), "mp4", MimeType.MPEG);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Saved to gallery',
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetsToImage(
            controller: _widgetsToImageController,
            child: Container(
              height: size.height * 0.6,
              child: Stack(
                children: [
                  Image.memory(widget.file),
                  Center(
                    child: Image.file(widget.image),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
