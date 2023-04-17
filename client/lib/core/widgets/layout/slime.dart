import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Slime extends StatelessWidget {
  final double width;
  final double height;

  const Slime({
    required this.width,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, (height * 0.3220512820512821).toDouble()),
      painter: RPSCustomPainter(),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.039341, size.height * 0.7455242);
    path_0.lineTo(size.width * 1.170136, size.height * 0.4148581);
    path_0.cubicTo(
        size.width * 1.173018,
        size.height * 0.4075718,
        size.width * 1.176497,
        size.height * 0.4010392,
        size.width * 1.180467,
        size.height * 0.3954630);
    path_0.cubicTo(
        size.width * 1.192828,
        size.height * 0.3780996,
        size.width * 1.200000,
        size.height * 0.3521159,
        size.width * 1.200000,
        size.height * 0.3246824);
    path_0.lineTo(size.width * 1.200000, size.height * -0.9118943);
    path_0.cubicTo(
        size.width * 1.200000,
        size.height * -1.155189,
        size.width * 1.085203,
        size.height * -1.352423,
        size.width * 0.9435897,
        size.height * -1.352423);
    path_0.lineTo(size.width * 0.1509308, size.height * -1.352423);
    path_0.cubicTo(
        size.width * 0.006484718,
        size.height * -1.352423,
        size.width * -0.1094536,
        size.height * -1.147533,
        size.width * -0.1053774,
        size.height * -0.8994626);
    path_0.lineTo(size.width * -0.08106205, size.height * 0.5803084);
    path_0.cubicTo(
        size.width * -0.07845128,
        size.height * 0.7391806,
        size.width * 0.03944897,
        size.height * 0.8030308,
        size.width * 0.09461564,
        size.height * 0.6754449);
    path_0.cubicTo(
        size.width * 0.1346144,
        size.height * 0.5829383,
        size.width * 0.2157782,
        size.height * 0.5858722,
        size.width * 0.2534782,
        size.height * 0.6811850);
    path_0.lineTo(size.width * 0.3010462, size.height * 0.8014449);
    path_0.cubicTo(
        size.width * 0.3275538,
        size.height * 0.8684581,
        size.width * 0.3830641,
        size.height * 0.8772643,
        size.width * 0.4162641,
        size.height * 0.8197269);
    path_0.lineTo(size.width * 0.4206718, size.height * 0.8120881);
    path_0.cubicTo(
        size.width * 0.4634949,
        size.height * 0.7378767,
        size.width * 0.5372667,
        size.height * 0.7826872,
        size.width * 0.5434231,
        size.height * 0.8866520);
    path_0.cubicTo(
        size.width * 0.5502256,
        size.height * 1.001529,
        size.width * 0.6368154,
        size.height * 1.039159,
        size.width * 0.6745923,
        size.height * 0.9436520);
    path_0.lineTo(size.width * 0.7581205, size.height * 0.7324758);
    path_0.cubicTo(
        size.width * 0.7923564,
        size.height * 0.6459207,
        size.width * 0.8672641,
        size.height * 0.6493965,
        size.width * 0.8987308,
        size.height * 0.7390000);
    path_0.cubicTo(
        size.width * 0.9302000,
        size.height * 0.8286035,
        size.width * 1.005105,
        size.height * 0.8320793,
        size.width * 1.039341,
        size.height * 0.7455242);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.4974359, size.height * 0.4405189),
        Offset(size.width * 0.4974359, size.height * 1.224670), [
      const Color(0xffC4858D).withOpacity(1),
      const Color(0xff7C5A5E).withOpacity(1)
    ], [
      0.458333,
      1
    ]);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
