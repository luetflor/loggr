import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:loggr/Graphs/GraphView.dart';
import 'package:provider/provider.dart';

import '../Data/LoggrData.dart';
import '../Data/LoggrPage.dart';
import '../DataSetAdder.dart';
import 'GridDataView.dart';
import 'ListDataView.dart';

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
  void initState() {
    if(widget.page.loading == LoadState.empty) {
      widget.page.load().then((value) => setState(() {}));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String typeText = view == View.List ? 'List' : 'Grid';
    LoggrData data = Provider.of<LoggrData>(context);
    Color textC = data.textColor;
    Color back = data.background;

    if(widget.page.loading != LoadState.loaded) {
      return Scaffold(
        backgroundColor: back,
        appBar: AppBar(
          iconTheme: IconThemeData(color: textC),
          backgroundColor: back,
          elevation: 0.0,
          centerTitle: true,
          title: Text(widget.page.title, style: TextStyle(color: textC)),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        )
      );
    }

    var scaf = Scaffold(
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
            expandedHeight: MediaQuery.of(context).size.height - 130,
            //Add some empty space on top where appbar is
            flexibleSpace: Column(children: <Widget>[
              Container(height: 120,),
              Expanded(child: GraphView())
            ],),
          ),

          //Data View Type Selector
          SliverList(delegate: SliverChildListDelegate([
            Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
              Container(
                child: Consumer<LoggrPage>(
                  builder: (context, page, child) => OutlineButton(
                    child: Text('Add Set',
                        style: TextStyle(color: textC)),
                    shape: StadiumBorder(),
                    onPressed: () => openSetAdder(context, page),
                  ),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
              ),
              Expanded(child: Container(),),
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
          ]),),

          if(view == View.List) ListDataView(),
          if(view == View.Grid) GridDataView(),
        ],
      ),
    );

    //Provide the Page Data
    return ChangeNotifierProvider<LoggrPage>.value(
      value: widget.page,
      builder: (context, child) => scaf,
    );
  }

  void openSetAdder(BuildContext context, LoggrPage page) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => DataSetAdder()));
    if (result != null) {
      if (result is DataSet) {
        page.addSet(result);
      }
    }
  }
}

showSetModal(BuildContext context, DataSet set, LoggrData data, LoggrPage page) {
  showModalBottomSheet(backgroundColor: data.background, context: context, builder: (context) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(height: 20,),
      getModalButton(context, 'Rename', () {}),
      getModalButton(context, 'Set as Input', () => set.type = Type.Input),
      getModalButton(context, 'Set as Output', () => set.type = Type.Output),
      getModalButton(context, 'Set as Nothing', () => set.type = Type.Nothing),
      getModalButton(context, 'Delete', () => page.removeSet(set), color: Colors.redAccent),
      Container(height: 30,)
    ],);
  });
}

Widget getModalButton(context, String text, onPress, {color}) {
  var col = color == null ? Colors.black : color;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: FlatButton(onPressed: () {onPress(); Navigator.pop(context);}, child: Text(text, style: TextStyle(fontSize: 25, color: col),)),
  );
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
    //Progress 1.0 -> list
    //         0.0 -> grid
    double extent = size.height < size.width ? size.height : size.width;
    double dist = extent/3.0;
    double marg = extent*0.1;
    for(int x=1; x<= 3; x++) {
      for(int y=1; y<=3; y++) {
        double posX = (1.0-progress)*dist*(x-0.5) + progress*extent*0.5*x;
        if(x > 1) posX += progress*0.5*extent; // Make the outer grid items disappear completely
        double width = (1.0-progress)*(dist-marg) + progress*(extent-marg);
        double height = (1.0-progress)*(dist-marg) + progress*(dist*0.4);
        canvas.drawRect(Rect.fromCenter(center: Offset(posX, dist*(y-0.5)), width: width, height: height), pen);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return running;
  }

}