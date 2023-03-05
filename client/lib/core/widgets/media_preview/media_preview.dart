import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mochi/core/utils/media_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class MediaPreview extends StatefulWidget {
  final String source;
  final String extension;
  final double width;
  final BoxFit fit;

  const MediaPreview({
    Key? key,
    required this.source,
    required this.extension,
    this.width = 300,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  _MediaPreviewState createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  late bool _isVideo;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _isVideo = MediaExtensions.video.any((v) => widget.extension == v);
    if (_isVideo) {
      _createTempFile(base64Decode(widget.source)).then((file) {
        _controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {});
          });
      });
    }
  }

  @override
  void dispose() {
    if (_isVideo) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<File> _createTempFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/temp.mp4');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    return _isVideo
        ? _controller.value.isInitialized
            ? SizedBox(
                width: widget.width,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              )
            : Container()
        : Image.memory(
            base64.decode(widget.source),
            width: widget.width,
            fit: widget.fit,
          );
  }
}
