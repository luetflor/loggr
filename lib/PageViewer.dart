import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrData.dart';
import 'Data/LoggrPage.dart';

class PageViewer extends StatefulWidget
{
  final LoggrPage page;

  const PageViewer(this.page, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageViewerState();
  }
}

enum View {
  List,
  Grid
}
class PageViewerState extends State<PageViewer>
{
  View view = View.List;

  @override
  Widget build(BuildContext context) {
    String typeText = view == View.List ? 'List' : 'Grid';
    Color textC = Provider.of<LoggrData>(context).textColor;
    Color back = Provider.of<LoggrData>(context).background;

    return Scaffold(
      backgroundColor: back,
      body: CustomScrollView(
        //Make the Graph View take 40% of the Screen initially (if possible else more) by scrolling down 60% of screen
        controller: ScrollController(initialScrollOffset: MediaQuery.of(context).size.height*0.6),
        slivers: <Widget>[
          //Graph View Top Bar
          SliverAppBar(
            iconTheme: IconThemeData(color: textC),
            backgroundColor: back,
            elevation: 0.0,
            centerTitle: true,
            title: Text(widget.page.title, style: TextStyle(color: textC)),
            expandedHeight: MediaQuery.of(context).size.height,
            //flexibleSpace: , TODO: Add Graph Drawer
          ),

          //Data View Type Selector
          SliverList(delegate: SliverChildListDelegate([
            Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Text(typeText),
              IconButton(
                icon: SwitchAnimIcon(view),
                onPressed: () => setState(() {
                  if(view == View.List)
                    view = View.Grid;
                  else if(view == View.Grid)
                    view = View.List;
                }),
              )
            ],),
            Divider(height: 4, thickness: 1, indent: 20, endIndent: 20),
            Container(height: 200)
          ]),),

          //TODO: Add Actual Data View
          //if(view == View.List) ListDataView(),
          //if(view == View.Grid) GridDataView()
        ],
      ),
    );
  }
}

class SwitchAnimIcon extends StatefulWidget
{
  final View view;

  const SwitchAnimIcon(this.view, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SwitchAnimIconState();
  }
}

class SwitchAnimIconState extends State<SwitchAnimIcon> with SingleTickerProviderStateMixin
{
  AnimationController controller;
  Animation anim;
  
  @override
  void initState() {
    controller = AnimationController(duration: Duration(seconds: 1), value: widget.view == View.List ? 1.0 : 0.0, vsync: this);
    controller.addListener(() => setState(() {}));
    anim = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    super.initState();
  }
  
  @override
  void didUpdateWidget(SwitchAnimIcon oldWidget) {
    if(widget.view == View.List) {
      controller.forward();
    } else if(widget.view == View.Grid) {
      controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  Widget build(BuildContext context) {
    //TODO: Add Rotation by 90 deg
    return Container(
      width: 20,
      height: 20,
      child: Transform.rotate(
        angle: (math.pi*0.5)*(1.0-anim.value),
        child: ClipRect(
          clipBehavior: Clip.antiAlias,
          child: CustomPaint(painter: AnimPainter(anim.value, controller.status == AnimationStatus.forward || controller.status == AnimationStatus.reverse)),
        ),
      ),
    );
  }
}

class AnimPainter extends CustomPainter
{
  double progress;
  bool running;
  
  Paint pen = Paint();
  
  AnimPainter(this.progress, this.running);
  
  @override
  void paint(Canvas canvas, Size size) {
    double extent = size.height < size.width ? size.height : size.width;
    double dist = extent/3.0;
    double marg = extent*0.1;
    for(int x=1; x<= 3; x++) {
      for(int y=1; y<=3; y++) {
        double posX = (1.0-progress)*dist*(x-0.5) + progress*extent*0.5*x;
        if(x > 1) posX += progress*0.5*extent; // Make the outer grid items disappear completely
        double width = (1.0-progress)*(dist-marg) + progress*(extent-marg);
        canvas.drawRect(Rect.fromCenter(center: Offset(posX, dist*(y-0.5)), width: width, height: dist-marg), pen);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return running;
  }

}