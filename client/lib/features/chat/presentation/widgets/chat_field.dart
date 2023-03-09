import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mochi/core/widgets/media_picker/media_picker.dart';
import 'package:mochi/core/widgets/media_preview/media_preview.dart';

class ChatField extends StatefulWidget {
  final void Function(String, String?) onSend;

  const ChatField({Key? key, required this.onSend}) : super(key: key);

  @override
  _ChatFieldState createState() => _ChatFieldState();
}

class _ChatFieldState extends State<ChatField> {
  final TextEditingController _textController = TextEditingController();
  bool _showImagePreview = false;
  String? _image;
  String? _imageExtension;

  void _onSubmitted() {
    if (_image != null && _imageExtension != null) {
      widget.onSend(_image!, _imageExtension);
    } else {
      widget.onSend(_textController.text, null);
    }

    _textController.clear();

    setState(() {
      _showImagePreview = false;
      _image = null;
      _imageExtension = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Stack(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration.collapsed(
                    hintText: !_showImagePreview ? 'Type a message...' : '',
                  ),
                  onChanged: (text) {
                    setState(() {
                      _showImagePreview = false;
                    });
                  },
                ),
                if (_showImagePreview &&
                    _image != null &&
                    _imageExtension != null)
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: MediaPreview(
                      source: _image!,
                      extension: _imageExtension!,
                      width: 30,
                    ),
                  ),
              ],
            ),
          ),
        ),
        MediaPicker(
          source: MediaSource.camera,
          onPicked: (path, extension) {
            setState(() {
              _showImagePreview = true;
              _image = path;
              _imageExtension = extension;
            });
          },
          child: const Icon(CupertinoIcons.camera_fill),
        ),
        const SizedBox(width: 8.0),
        MediaPicker(
          source: MediaSource.gallery,
          onPicked: (path, extension) {
            setState(() {
              _showImagePreview = true;
              _image = path;
              _imageExtension = extension;
            });
          },
          child: const Icon(CupertinoIcons.photo_fill),
        ),
        const SizedBox(width: 8.0),
        GestureDetector(
          onTap: _onSubmitted,
          child: const Icon(CupertinoIcons.paperplane_fill),
        ),
      ],
    );
  }
}
