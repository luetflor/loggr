import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loggr/DataSetAdder.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrData.dart';
import 'Data/LoggrPage.dart';
import 'PageViewer.dart';

class ListDataView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListDataViewState();
  }
}

class ListDataViewState extends State<ListDataView> {
  List<TextEditingController> controller = List<TextEditingController>();
  List<FocusNode> nodes = List<FocusNode>();

  void openSetAdder(BuildContext context, LoggrPage page) async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => DataSetAdder()));
    if (result != null) {
      if (result is DataSet) {
        page.addSet(result);
      }
    }
  }

  void submitData(LoggrPage page) {
    for(int i=0; i<page.sets.length; i++) {
      //Add Parsed Value to DataSet
      page.sets[i].addValue(double.parse(controller[i].text.replaceAll(',', '.')));
      //Clear Textfield
      controller[i].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    LoggrData data = Provider.of<LoggrData>(context);
    return Consumer<LoggrPage>(
      builder: (BuildContext context, page, Widget child) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            //Build TextEditingControllers and FocusNodes if necessary
            for (int i = controller.length; i < page.sets.length; i++) {
              controller.add(TextEditingController());
              nodes.add(FocusNode());
            }
            //Bottom Bar displaying Button Options
            if (index == page.sets.length + 1)
              return Row(
                children: <Widget>[
                  Container(
                    child: OutlineButton(
                      child: Text('Add Set',
                          style: TextStyle(color: data.textColor)),
                      shape: StadiumBorder(),
                      onPressed: () => openSetAdder(context, page),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  Expanded(child: Container()),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: RaisedButton(
                      child: Text('Submit',
                          style: TextStyle(color: data.background)),
                      color: data.accent,
                      shape: StadiumBorder(),
                      onPressed: () => submitData(page),
                    ),
                  )
                ],
              );
            if (index == page.sets.length)
              return Divider(
                indent: 30,
                endIndent: 30,
              );
            //Else return Set Element
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onLongPress: () => showSetModal(context, page.sets[index], data, page),
                child: Row(
                  children: <Widget>[
                    Text(page.sets[index].name, style: TextStyle(color: data.textColor, fontSize: 20)),
                    if(page.sets[index].type == Type.Input) Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: ShapeDecoration(shape: StadiumBorder(), color: data.accent),
                      child: Text('In', style: TextStyle(color: data.background),),
                    ),
                    if(page.sets[index].type == Type.Output) Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: ShapeDecoration(shape: StadiumBorder(), color: data.accent),
                      child: Text('Out', style: TextStyle(color: data.background),),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 1,
                    ),
                    Container(
                      width: 130,
                      decoration: ShapeDecoration(
                          shape: StadiumBorder(), color: data.backgroundAlt),
                      child: TextField(
                        controller: controller[index],
                        focusNode: nodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                        decoration: InputDecoration.collapsed(hintText: '---'),
                        style: TextStyle(color: data.textColor),
                        onSubmitted: (text) {
                          nodes[index].unfocus();
                          if(index < nodes.length-1) nodes[index+1].requestFocus();
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }, childCount: page.sets.length + 2),
        );
      },
    );
  }
}
