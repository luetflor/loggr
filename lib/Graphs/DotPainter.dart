import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:loggr/Data/LoggrPage.dart';

class DotPainter extends CustomPainter
{
  final BLUR_OUT = 15.0;

  double minX, minY;
  double extentX, extentY;

  DataSet input;
  List<DataSet> output;
  LoggrData data;

  DotPainter(this.minX, this.minY, this.extentX, this.extentY, this.input, this.output, this.data);

  @override
  void paint(Canvas canvas, Size size) {
    Paint pencil = Paint()
      ..color = data.accent
      ..style = PaintingStyle.fill;

    Paint fade = Paint()
      ..color = data.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for(DataSet set in output) {
      for(int i=0; i<set.values.length; i++) {
        if(input.values[i] != null && set.values[i] != null) {
          Offset pos = Offset(toScreenX(input.values[i], size), toScreenY(set.values[i], size));
          //Check for bounds
          if(pos.dx >= BLUR_OUT && pos.dy >= BLUR_OUT && pos.dx <= size.width-BLUR_OUT && pos.dy <= size.height-BLUR_OUT)
            canvas.drawCircle(pos, 5.0, pencil);
          else if(pos.dx >= 0 && pos.dy >= 0 && pos.dx <= size.width && pos.dy <= size.height)
            canvas.drawCircle(pos, 4.0, fade);
        }
      }
    }
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    //TODO: Determine if needs to be changed
    return true;
  }

}