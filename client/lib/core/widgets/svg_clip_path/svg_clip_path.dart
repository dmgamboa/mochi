import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class SvgClipPath extends StatelessWidget {
  final String path;
  final Widget clipped;

  SvgClipPath({required this.path, required this.clipped});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final pathMetrics = parseSvgPathData(path).computeMetrics();

      final pathToClip = Path();
      for (var metric in pathMetrics) {
        pathToClip.addPath(metric.extractPath(0, metric.length),
            Offset.zero.translate(0, constraints.maxHeight / 2));
      }

      final pathBounds = pathToClip.getBounds();
      final clippedWidth = constraints.maxWidth;
      final clippedHeight =
          clippedWidth * (pathBounds.height / pathBounds.width);

      return ClipPath(
        clipper: _SvgPathClipper(path: pathToClip),
        child: SizedBox(
          width: clippedWidth,
          height: clippedHeight,
          child: clipped,
        ),
      );
    });
  }
}

class _SvgPathClipper extends CustomClipper<Path> {
  final Path path;

  _SvgPathClipper({required this.path});

  @override
  Path getClip(Size size) {
    return path;
  }

  @override
  bool shouldReclip(_SvgPathClipper oldClipper) {
    return oldClipper.path != path;
  }
}
