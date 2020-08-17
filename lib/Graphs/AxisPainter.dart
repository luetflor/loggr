import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:loggr/Data/LoggrPage.dart';

class AxisPainter extends CustomPainter
{

  double minX, minY;
  double extentX, extentY;

  DataSet input;
  List<DataSet> output;
  LoggrData data;

  final coeffs = [0.25, 0.5, 0.75, 1];
  final margin = 20.0;
  final pen = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

  AxisPainter(this.minX, this.minY, this.extentX, this.extentY, this.input, this.output, this.data);

  @override
  void paint(Canvas canvas, Size size) {
    pen.color = data.backgroundAlt;

    Path axis = Path();
    axis.moveTo(margin, margin);
    axis.lineTo(margin, size.height-margin);
    axis.lineTo(size.width-margin, size.height-margin);
    canvas.drawPath(axis, pen);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double toScreenX(double graphX, Size size) {
    double origin = graphX - minX;
    return origin/extentX*size.width;
  }

  double toScreenY(double graphY, Size size) {
    double screenPercentage = (graphY - minY)/extentY;
    double inverted = 1.0 - screenPercentage;
    return inverted*size.height;
  }

  double toGraphX(double screenX, Size size) {
    double scaled = screenX/size.width*extentX;
    return scaled + minX;
  }

  double toGraphY(double screenY, Size size) {
    double scaled = screenY/size.height*extentY;
    return (extentY - scaled) + minY;
  }

}