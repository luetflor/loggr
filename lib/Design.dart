import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrData.dart';

class Surface extends StatelessWidget
{
  final double elevation;
  final Color color;
  final BoxConstraints constraints;
  final double width, height;
  final EdgeInsets margin, padding;
  final AlignmentGeometry alignment;

  final Widget child;

  const Surface({Key key, this.elevation = 1.0, this.color, this.child, this.constraints, this.width, this.height, this.alignment, this.margin, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color back;
    if(color == null) {
      if(Provider.of<LoggrData>(context) != null)
        back = Provider.of<LoggrData>(context).background;
      else
        back = Colors.white;
    } else {
      back = color;
    }
    return Container(
      margin: margin,
      padding: padding,
      constraints: constraints,
      width: width,
      height: height,
      alignment: alignment,
      child: child,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: back,
        boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(elevation, elevation), blurRadius: elevation.abs()*2),
            BoxShadow(color: Colors.white, offset: -Offset(elevation, elevation), blurRadius: elevation.abs()*2),
          ]
      ),
    );
  }

}


class SurfaceShape extends StatelessWidget
{
  final double elevation;
  final Color color;
  final BoxConstraints constraints;
  final double width, height;
  final AlignmentGeometry alignment;
  final ShapeBorder shape;

  final Widget child;

  const SurfaceShape({Key key, this.elevation = 1.0, this.color, this.child, this.constraints, this.width, this.height, this.alignment, this.shape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color back;
    if(color == null) {
      if(Provider.of<LoggrData>(context) != null)
        back = Provider.of<LoggrData>(context).background;
      else
        back = Colors.white;
    } else {
      back = color;
    }
    return Container(
      constraints: constraints,
      width: width,
      height: height,
      alignment: alignment,
      child: child,
      decoration: ShapeDecoration(
        shape: shape,
        color: back,
          shadows: [
            BoxShadow(color: Colors.black, offset: Offset(elevation, elevation), blurRadius: elevation.abs()),
            BoxShadow(color: color == null ? Colors.white : color, offset: -Offset(elevation, elevation), blurRadius: elevation.abs()),
          ]
      ),
    );
  }
}

class AddFAB extends StatefulWidget
{
  final Function(String) onSubmit;

  const AddFAB({Key key, this.onSubmit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddFABState();
  }
}

class AddFABState extends State<AddFAB> with SingleTickerProviderStateMixin
{
  bool editing = false;
  AnimationController controller;
  Animation<double> anim;

  @override
  void initState() {
    controller = AnimationController(duration: Duration(milliseconds: 150), vsync: this);
    controller.addListener(() => setState(() {}));
    controller.addStatusListener((status) {
      if(status == AnimationStatus.dismissed) {
        setState(() => editing = false);
      }
    });
    var animb = CurvedAnimation(curve: Curves.easeInOut, parent: controller);
    anim = Tween<double>(begin: 0, end: 150).animate(animb);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var labelEmpty = Icon(Icons.add);
    var labelWrite = Row(children: <Widget>[
      Container(
        width: anim.value,
        child: TextField(
          decoration: InputDecoration.collapsed(hintText: 'name', hintStyle: TextStyle(color: Colors.grey)),
          style: TextStyle(color: Provider.of<LoggrData>(context).background),
          textAlign: TextAlign.center,
          autofocus: true,
          onSubmitted: (txt) {
            if(widget.onSubmit != null) widget.onSubmit(txt);
            setState(() => editing = false);
          },
        ),
      ),
      Icon(Icons.close)
    ],);
    if(editing) return FloatingActionButton.extended(
        onPressed: () => setState(() {
          controller.reverse();
        }),
        label: labelWrite
    );
    return FloatingActionButton(
      onPressed: () => setState(() {
        editing = true;
        controller.forward();
      }),
      child: labelEmpty,
    );
  }
}