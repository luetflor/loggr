import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:loggr/Data/LoggrPage.dart';
import 'package:loggr/Graphs/DotPainter.dart';
import 'package:provider/provider.dart';

class GraphView extends StatefulWidget
{
  final Function(bool) showRestoreAction;

  const GraphView(this.showRestoreAction, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GraphViewState();
  }
}

class GraphViewState extends State<GraphView> with TickerProviderStateMixin
{
  //Dimensions of the Viewport
  bool manuallyChanged = false;

  double oldMinX=0.0, oldMinY=0.0;
  double oldExtX=1.0, oldExtY=1.0;

  //Scaling factor used in ScaleUpdate method to determine relative change in scaling
  Offset oldScale = Offset(1.0, 1.0);
  Offset oldFocal = Offset(0.0, 0.0);

  AnimationController minX, minY;
  AnimationController extentX, extentY;

  final duration = Duration(milliseconds: 500);
  final curve = Curves.easeInOut;

  @override
  void initState() {
    minX = AnimationController(vsync: this, duration: Duration(milliseconds: 300),
        value: 0.0, upperBound: double.infinity, lowerBound: double.negativeInfinity)
      ..addListener(() => setState(() {}));
    minY = AnimationController(vsync: this, duration: Duration(milliseconds: 300),
        value: 0.0, upperBound: double.infinity, lowerBound: double.negativeInfinity)
      ..addListener(() => setState(() {}));
    extentX = AnimationController(vsync: this, duration: Duration(milliseconds: 300),
        value: 1.0, upperBound: double.infinity, lowerBound: double.negativeInfinity)
      ..addListener(() => setState(() {}));
    extentY = AnimationController(vsync: this, duration: Duration(milliseconds: 300),
        value: 1.0, upperBound: double.infinity, lowerBound: double.negativeInfinity)
      ..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoggrPage>(
      builder: (context, page, child) {
        //Determine Dimensions if not changed manually
        if(!manuallyChanged) determineDefaultScaling(page);
        return GestureDetector(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.topRight,
            children: <Widget>[
              CustomPaint(painter: DotPainter(
                minX.value,
                minY.value,
                extentX.value,
                extentY.value,
                page.inputs[0],
                page.outputs,
                Provider.of<LoggrData>(context)
              ),),
            ],
          ),
          onScaleStart: (details) {
            oldScale = Offset(1, 1);
            oldFocal = details.localFocalPoint;
          },
          onScaleUpdate: (details) => panAndScale(details, context),
        );
      },
    );
  }

  void panAndScale(ScaleUpdateDetails details, BuildContext context) {
    if(!manuallyChanged) {
      widget.showRestoreAction(true);
    }
    manuallyChanged = true;
    //Scaling
    //Add a min Scale to avoid dividing by zero
    Offset minScale = Offset(math.max(details.horizontalScale, 0.01), math.max(details.verticalScale, 0.01));
    Offset relScale = Offset(minScale.dx/oldScale.dx, minScale.dy/oldScale.dy);
    extentX.value /= relScale.dx;
    extentY.value /= relScale.dy;
    oldScale = Offset(minScale.dx, minScale.dy);

    //TODO: Panning to scale around focal point
    var scaling = Offset(extentX.value/context.size.width, extentY.value/context.size.height);
    //var deltascale = Offset(details.localFocalPoint.dx*scaling.dx, details.localFocalPoint.dy*scaling.dy);


    //Panning
    var delta = details.localFocalPoint - oldFocal;
    minX.value -= delta.dx*scaling.dx;
    minY.value += delta.dy*scaling.dy;
    oldFocal = details.localFocalPoint;

    //Update old min/extent values for right jump back
    oldMinX = minX.value;
    oldMinY = minY.value;
    oldExtX = extentX.value;
    oldExtY = extentY.value;
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
    double marginX = minX == 0.0 ? 0.1 : (maxX-minX)*0.1;
    double marginY = minY == 0.0 ? 0.1 : (maxY-minY)*0.1;
    var aminX = minX-marginX;
    var aminY = minY-marginY;
    var aextentX = maxX-minX+2*marginX;
    var aextentY = maxY-minY+2*marginY;

    //Animate if any values changed
    if(oldMinX != aminX || oldMinY != aminY || oldExtX != aextentX || oldExtY != aextentY) {
      print('Changed');
      this.minX.animateTo(aminX, duration: duration, curve: curve);
      this.minY.animateTo(aminY, duration: duration, curve: curve);
      this.extentX.animateTo(aextentX, duration: duration, curve: curve);
      this.extentY.animateTo(aextentY, duration: duration, curve: curve);
    }

    //Set old values
    oldMinX = aminX;
    oldMinY = aminY;
    oldExtX = aextentX;
    oldExtY = aextentY;
  }

  void restoreDefaultScaling() {
    setState(() => manuallyChanged = false);
    widget.showRestoreAction(false);
  }
}