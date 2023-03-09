import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mochi/core/utils/media_extensions.dart';

enum MediaType { image, video }

enum MediaSource { camera, gallery }

class MediaPicker extends StatelessWidget {
  final Function(String)? onError;
  final Function(String, String) onPicked;
  final Duration maxDuration = const Duration(seconds: 10);
  final MediaType type;
  final MediaSource source;
  final Widget child;

  const MediaPicker({
    Key? key,
    this.onError,
    required this.onPicked,
    this.type = MediaType.image,
    this.source = MediaSource.camera,
    required this.child,
  }) : super(key: key);

  Future<void> _onPressed() async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedFile;

    switch (type) {
      case MediaType.image:
        pickedFile = await picker.pickImage(
          source: source == MediaSource.camera
              ? ImageSource.camera
              : ImageSource.gallery,
          imageQuality: 75,
          maxWidth: 500,
          maxHeight: 500,
        );
        break;
      case MediaType.video:
        pickedFile = await picker.pickVideo(
          source: source == MediaSource.camera
              ? ImageSource.camera
              : ImageSource.gallery,
          maxDuration: maxDuration,
        );
        break;
    }

    if (pickedFile != null) {
      final String extension = pickedFile.path.split('.').last;

      final bool isValidExtension =
          (MediaExtensions.image + MediaExtensions.video)
              .any((ext) => extension == ext);
      if (!isValidExtension) {
        onError?.call('Invalid file extension');
        return;
      }
      final bytes = await pickedFile.readAsBytes();
      final toBase64 = base64Encode(bytes);

      onPicked(toBase64, extension);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: child,
    );
  }
}
