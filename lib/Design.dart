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

  const Surface({Key key, this.elevation = 3.0, this.color, this.child, this.constraints, this.width, this.height, this.alignment, this.margin, this.padding}) : super(key: key);

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
            BoxShadow(color: Colors.black.withAlpha(100), offset: Offset(elevation, elevation), blurRadius: elevation.abs()*2),
            BoxShadow(color: Colors.white.withAlpha(500), offset: -Offset(elevation, elevation), blurRadius: elevation.abs()*2),
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
  final EdgeInsets margin, padding;
  final AlignmentGeometry alignment;
  final ShapeBorder shape;

  final Widget child;

  const SurfaceShape({Key key, this.elevation = 1.0, this.color, this.child, this.constraints, this.width, this.height, this.alignment, this.shape, this.margin, this.padding}) : super(key: key);

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
      margin: margin,
      padding: padding,
      alignment: alignment,
      child: child,
      decoration: ShapeDecoration(
        shape: shape,
        color: back,
          shadows: [
            BoxShadow(color: Colors.black, offset: Offset(elevation, elevation), blurRadius: elevation.abs()*2),
            BoxShadow(color: Colors.white, offset: -Offset(elevation, elevation), blurRadius: elevation.abs()*2),
          ]
      ),
    );
  }
}

class SurfaceButton extends StatefulWidget
{
  final double maxElevation;
  final Color color;
  final EdgeInsets margin, padding;
  final BoxConstraints constraints;
  final double width, height;
  final AlignmentGeometry alignment;
  final ShapeBorder shape;
  final Function onPress;

  final Widget child;

  final bool pressed;

  const SurfaceButton(this.pressed, {Key key, this.maxElevation = 1.0, this.color,
    this.constraints, this.width, this.height, this.alignment, this.shape = const StadiumBorder(),
    this.child, this.onPress, this.margin, this.padding}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SurfaceButtonState();
  }
}

class SurfaceButtonState extends State<SurfaceButton> with SingleTickerProviderStateMixin
{
  AnimationController controller;
  Animation anim;

  @override
  void initState() {
    controller = AnimationController(value: widget.pressed ? -1.0 : 1.0, vsync: this, duration: Duration(milliseconds: 300));
    controller.addListener(() => setState(() {}));
    var a = CurvedAnimation(parent: controller, curve: Curves.easeInOutQuint);
    anim = Tween<double>(begin: -widget.maxElevation, end: widget.maxElevation).animate(a);
    super.initState();
  }

  @override
  void didUpdateWidget(SurfaceButton oldWidget) {
    if(widget.pressed)
      controller.reverse();
    else
      controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: SurfaceShape(
        margin: widget.margin,
        padding: widget.padding,
        color: widget.color,
        constraints: widget.constraints,
        width: widget.width,
        height: widget.height,
        alignment: widget.alignment,
        shape: widget.shape,
        child: widget.child,
        elevation: anim.value,
      ),
      onTap: () => widget.onPress(),
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