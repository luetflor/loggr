import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loggr/DataSetAdder.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrData.dart';
import 'Data/LoggrPage.dart';

class ListDataView extends StatelessWidget
{
  void openSetAdder(BuildContext context, LoggrPage page) async {
    var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => DataSetAdder()));
    if(result != null) {
      if(result is DataSet) {
        page.addSet(result);
      }
    }
  }

  void submitData(LoggrPage page) {

  }

  @override
  Widget build(BuildContext context) {
    LoggrData data = Provider.of<LoggrData>(context);
    return Consumer<LoggrPage>(
      builder: (BuildContext context, page, Widget child) {
        return SliverList(delegate: SliverChildBuilderDelegate(
            (context, index) {
              //Bottom Bar displaying Button Options
              if(index == page.sets.length+1)
                return Row(children: <Widget>[
                  Container(
                    child: OutlineButton(
                        child: Text('Add Set', style: TextStyle(color: data.textColor)),
                        shape: StadiumBorder(),
                        onPressed: () => openSetAdder(context, page),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: RaisedButton(
                      child: Text('Submit', style: TextStyle(color: data.background)),
                      color: data.accent,
                      shape: StadiumBorder(),
                      onPressed: () => submitData(page),
                    ),
                  )
                ],);
              if(index == page.sets.length)
                return Divider(indent: 30, endIndent: 30,);
              //Else return Set Element
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Text(page.sets[index].name, style: TextStyle(color: data.textColor, fontSize: 20)),
                      onLongPress: () {}, //Open Set Options
                    ),
                    Expanded(child: Container(), flex: 1,),
                    Container(
                      width: 130,
                      decoration: ShapeDecoration(shape: StadiumBorder(), color: data.backgroundAlt),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: InputDecoration.collapsed(hintText: '---'),
                        style: TextStyle(color: data.textColor),
                      ),
                    )
                  ],
                ),
              );
            },
            childCount: page.sets.length+2
        ),);
      },
    );
  }

}