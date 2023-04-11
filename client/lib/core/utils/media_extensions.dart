class MediaExtensions {
  static RegExp isWebResource = RegExp(
      r"^https?:\/\/[\w\-]+(\.[\w\-]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-@?^=%&/~\+#])?\.\w+$");

  static const List<String> video = [
    'mp4',
    'avi',
    'mov',
    'wmv',
    'flv',
    'webm',
    'mkv',
    '3gp',
    'm4v',
    'mpg',
  ];

  static const List<String> image = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
  ];
}
