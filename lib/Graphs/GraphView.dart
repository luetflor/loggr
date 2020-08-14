import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:loggr/Data/LoggrPage.dart';
import 'package:loggr/Graphs/DotPainter.dart';
import 'package:provider/provider.dart';

class GraphView extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return GraphViewState();
  }
}

class GraphViewState extends State<GraphView> with TickerProviderStateMixin
{
  //Dimensions of the Viewport, which animate when changed using animateTo
  bool manuallyChanged = false;
  double minX, minY;
  double extentX, extentY;

  final animDuration = Duration(milliseconds: 300);
  final animCurve = Curves.easeInOut;

  @override
  void initState() {
    /*minX = AnimationController(vsync: this, duration: animDuration, value: 0.0)
      ..addListener(() => setState(() {}));
    minY = AnimationController(vsync: this, duration: animDuration, value: 0.0)
      ..addListener(() => setState(() {}));
    extentX = AnimationController(vsync: this, duration: animDuration, value: 1.0)
      ..addListener(() => setState(() {}));
    extentY = AnimationController(vsync: this, duration: animDuration, value: 1.0)
      ..addListener(() => setState(() {}));*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoggrPage>(
      builder: (context, page, child) {
        //Determine Dimensions if not changed manually TODO: Only update if changed
        if(!manuallyChanged) determineDefaultScaling(page);
        return GestureDetector(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CustomPaint(painter: DotPainter(
                minX,
                minY,
                extentX,
                extentY,
                page.inputs[0],
                page.outputs,
                Provider.of<LoggrData>(context)
              ),)
            ],
          ),
          onScaleUpdate: (details) {},
        );
      },
    );
  }

  void determineDefaultScaling(LoggrPage page) {
    DataSet input = page.inputs[0];
    double maxX = double.negativeInfinity;
    double minX = double.infinity;
    for(double val in input.values) {
      if(val != null && val != double.nan) {
        if (val > maxX) maxX = val;
        if (val < minX) minX = val;
      }
    }
    double maxY = double.negativeInfinity;
    double minY = double.infinity;
    for(DataSet set in page.outputs) {
      for(double val in set.values) {
        if(val != null && val != double.nan) {
          if (val > maxY) maxY = val;
          if (val < minY) minY = val;
        }
      }
    }
    //Animate to them and add minimal extent
    double marginX = minX == 0.0 ? 0.1 : minX*0.1;
    double marginY = minY == 0.0 ? 0.1 : minY*0.1;
    this.minX = minX-marginX;
    this.minY = minY-marginY;
    this.extentX = maxX-minX+2*marginX;
    this.extentY = maxY-minY+2*marginY + 0.05/(maxY-minY); //Adjust for AppBar
  }
}