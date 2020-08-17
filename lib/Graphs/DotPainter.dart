import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:loggr/Data/LoggrPage.dart';

class DotPainter extends CustomPainter
{
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

    for(DataSet set in output) {
      for(int i=0; i<set.values.length; i++) {
        if(input.values[i] != null && set.values[i] != null) {
          Offset pos = Offset(toScreenX(input.values[i], size), toScreenY(set.values[i], size));
          canvas.drawCircle(pos, 5.0, pencil);
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