import 'package:flutter/material.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrPage.dart';
import 'Design.dart';

class DataSetAdder extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return DataSetState();
  }
}

enum Type {
  Number,
  Function
}
class DataSetState extends State<DataSetAdder>
{
  Type type = Type.Number;
  DataSet _workingSet = DataSet('');

  //Check validity of Data and submit
  void submit() {
    if(checkData()) {
      //return the DataSet
      Navigator.pop(context, _workingSet);
    }
  }

  //Checks if the fields are legal
  bool checkData() {
    if(type == Type.Function) return false; //Bc currently not implemented
    if(_workingSet.name.trim().isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    bool legal = checkData();
    LoggrData data = Provider.of<LoggrData>(context);
    TextStyle titleStyle = TextStyle(color: data.textColor, fontSize: 25);
    TextStyle fieldStyle = TextStyle(color: data.textColor, fontSize: 20);
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[

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
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: <Widget>[
              Text('Type:', style: titleStyle, textAlign: TextAlign.start),
              Expanded(child: Container(), flex: 3,),
              Surface(margin: EdgeInsets.all(5.0), width: 50, height: 50, child: Center(child: Text('1.23')),), //TODO: Change to Button
              Surface(margin: EdgeInsets.all(5.0), width: 50, height: 50, child: Center(child: Icon(Icons.functions)),),
              Expanded(child: Container(), flex: 1,),
            ],
          ),
        ),

      ],),
    );
  }
}