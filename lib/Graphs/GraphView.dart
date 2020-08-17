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
  //Dimensions of the Viewport
  bool manuallyChanged = false;

  double oldMinX=0.0, oldMinY=0.0;
  double oldExtX=1.0, oldExtY=1.0;

  AnimationController controller;
  Animation<double> curvedAnimation;
  Animation<double> minX, minY;
  Animation<double> extentX, extentY;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      ..addListener(() => setState(() {}));
    curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    minX = Tween(begin: 0.0, end: 0.0).animate(curvedAnimation);
    minY = Tween(begin: 0.0, end: 0.0).animate(curvedAnimation);
    extentX = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);
    extentY = Tween(begin: 0.0, end: 1.0).animate(curvedAnimation);
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
            children: <Widget>[
              CustomPaint(painter: DotPainter(
                minX.value,
                minY.value,
                extentX.value,
                extentY.value,
                page.inputs[0],
                page.outputs,
                Provider.of<LoggrData>(context)
              ),)
            ],
          ),
          onScaleUpdate: (details) {
            //TODO: Add Panning and Scaling of graph
          },
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
    var aminX = minX-marginX;
    var aminY = minY-marginY;
    var aextentX = maxX-minX+2*marginX;
    var aextentY = maxY-minY+2*marginY;

    //Animate if any values changed
    if(oldMinX != aminX || oldMinY != aminY || oldExtX != aextentX || oldExtY != aextentY) {
      this.minX = Tween(begin: oldMinX, end: aminX).animate(curvedAnimation);
      this.minY = Tween(begin: oldMinY, end: aminY).animate(curvedAnimation);
      this.extentX = Tween(begin: oldExtX, end: aextentX).animate(curvedAnimation);
      this.extentY = Tween(begin: oldExtY, end: aextentY).animate(curvedAnimation);
      controller.forward(from: 0.0);
    }

    //Set old values
    oldMinX = aminX;
    oldMinY = aminY;
    oldExtX = aextentX;
    oldExtY = aextentY;
  }
}