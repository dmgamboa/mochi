import 'package:flutter/material.dart';

import '../svg_clip_path/svg_clip_path.dart';

class SlimePath extends StatelessWidget {
  final Widget child;

  const SlimePath({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgClipPath(
      path:
          "M62.6,47.5c17.7-16.3,48.7-15.5,65.3,1.6c16.6,17.2,47.5,28.9,65.3,12.6l45.4-31.9c18.3-16.8,51.9-8.2,55.7,14.5c3.2,20.3,31.5,9,51-3.3l9.8-6.3c16.2-10.3,39.1-8.5,52.8,4.1l23.2,21.3c19,17.5,51.8,18.1,71.7,1.3c30.4-25.6,82.9-8.7,84.4,27.3l0.7,16.4l0,0V0H0v105.1c0.2-0.2,0.5-0.4,0.7-0.6L62.6,47.5z",
      clipped: child,
    );
  }
}
