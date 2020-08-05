import 'package:flutter/material.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrPage.dart';
import 'Design.dart';
import 'FormulaEditor.dart';

class DataSetAdder extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return DataSetState();
  }
}

enum ValueType {
  Number,
  Function
}
class DataSetState extends State<DataSetAdder> with SingleTickerProviderStateMixin
{
  ValueType type = ValueType.Number;
  DataSet _workingSet = DataSet('');

  AnimationController controller;
  Animation animType;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    controller.addListener(() => setState(() {}));
    controller.forward(); // Start of animating in
    animType = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    super.initState();
  }

  //Check validity of Data and submit
  void submit() {
    if(checkData()) {
      //return the DataSet
      Navigator.pop(context, _workingSet);
    }
  }

  //Checks if the fields are legal
  bool checkData() {
    if(type == ValueType.Function) return false; //Bc currently not implemented
    if(_workingSet.name.trim().isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool legal = checkData();
    LoggrData data = Provider.of<LoggrData>(context);
    TextStyle titleStyle = TextStyle(color: data.textColor, fontSize: 25);
    TextStyle fieldStyle = TextStyle(color: data.textColor, fontSize: 20);
    Widget typeWidget;
    switch(type) {
      case ValueType.Number: typeWidget = NumberTypeEditor(titleStyle, _workingSet, setParentState: setState,);
        break;
      case ValueType.Function: typeWidget = FunctionTypeEditor(titleStyle);
        break;
    }
    return Scaffold(
      backgroundColor: data.background,
      appBar: AppBar(
        backgroundColor: data.background,
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(color: data.textColor),
        title: Text('Add Dataset', style: TextStyle(color: data.textColor),),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: legal ? data.accent : data.backgroundAlt,
        disabledElevation: 0.0,
        child: Icon(Icons.check, color: data.background,),
        onPressed: legal ? () => submit() : null,
      ),
      body: Column(mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

        //Title Editor
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(children: <Widget>[
            Text('Name:', style: titleStyle,),
            Expanded(child: Container(),),
            Container(
              width: 170,
              decoration: ShapeDecoration(shape: StadiumBorder(), color: data.backgroundAlt),
              child: TextField(
                autofocus: true,
                textAlign: TextAlign.center,
                style: fieldStyle,
                decoration: InputDecoration.collapsed(hintText: 'name'),
                onChanged: (text) => setState(() => _workingSet.name = text),
              ),
            )
          ],),
        ),

        //Type Selector
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            children: <Widget>[
              Text('Type:', style: titleStyle, textAlign: TextAlign.start),
              Expanded(child: Container(), flex: 3,),
              SurfaceSwitch(
                type == ValueType.Number,
                margin: EdgeInsets.all(5),
                child: Center(child: Text('1.23'),),
                width: 50, height: 50,
                onPress: () => setState(() {
                  type = ValueType.Number;
                  controller.forward(from: 0.0);
                }),
              ),
              SurfaceSwitch(
                type == ValueType.Function,
                margin: EdgeInsets.all(5),
                child: Center(child: Icon(Icons.functions),),
                width: 50, height: 50,
                onPress: () => setState(() {
                  type = ValueType.Function;
                  controller.forward(from: 0.0);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FormulaEditor(title: 'Add Function')));
                }),
              ),
              Expanded(child: Container(), flex: 1,),
            ],
          ),
        ),

        //Type Data Editor
        Expanded(
          child: Surface(
            elevation: -animType.value,
            constraints: BoxConstraints.expand(),
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(20),
            child: Opacity(child: typeWidget, opacity: animType.value),
          ),
        )
      ],),
    );
  }
}


class NumberTypeEditor extends StatelessWidget
{
  final TextStyle titleStyle;
  final Function setParentState;
  DataSet workingSet;

  NumberTypeEditor(this.titleStyle, this.workingSet, {Key key, this.setParentState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.max, children: <Widget>[
      Text('Numbers', style: titleStyle,),
      Row(children: <Widget>[
        Text('Axis:', style: titleStyle,),
        Expanded(child: Container()),
        SurfaceSwitch(
          workingSet.type == Type.Input,
          margin: EdgeInsets.all(5),
          child: Center(child: Text('In'),),
          width: 50, height: 50,
          onPress: () => setParentState(() => workingSet.type = Type.Input),
        ),
        SurfaceSwitch(
          workingSet.type == Type.Output,
          margin: EdgeInsets.all(5),
          child: Center(child: Text('Out'),),
          width: 50, height: 50,
          onPress: () => setParentState(() => workingSet.type = Type.Output),
        ),
        SurfaceSwitch(
          workingSet.type == Type.Nothing,
          margin: EdgeInsets.all(5),
          child: Center(child: Text('None'),),
          width: 50, height: 50,
          onPress: () => setParentState(() => workingSet.type = Type.Nothing),
        ),
        Expanded(child: Container(),)
      ],)
    ],);
  }

}

class FunctionTypeEditor extends StatelessWidget
{
  final TextStyle titleStyle;

  const FunctionTypeEditor(this.titleStyle, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Text('Function', style: titleStyle,),
      Text('Functionality yet to come!')
    ],);
  }

}