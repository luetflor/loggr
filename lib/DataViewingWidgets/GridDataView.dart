import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Data/LoggrData.dart';
import '../Data/LoggrPage.dart';
import 'PageViewer.dart';

class GridDataView extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return GridDataState();
  }

}

class GridDataState extends State<GridDataView>
{
  List<List<TextEditingController>> controllers = List();
  List<List<FocusNode>> nodes = List();

  @override
  Widget build(BuildContext context) {
    LoggrData data = Provider.of<LoggrData>(context);
    TextStyle style = TextStyle(color: data.textColor, fontSize: 20.0);
    return Consumer<LoggrPage>(
      builder: (context, page, child) {
        // Add a single child as a sliver
        double height = 50;
        double width = MediaQuery.of(context).size.width/page.sets.length;
        if(page.sets.length > 0) {
          makeControllers(page.sets.length, page.sets[0].values.length, page);
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: page.sets.length, childAspectRatio: width/height),
            delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  int col = (index/page.sets.length).floor()-1;
                  int row = index%page.sets.length;
                  //Title Bar
                  if(col == -1) return Center(child: GestureDetector(
                    child: Text(page.sets[row].name, style: style),
                    onLongPress: () => showSetModal(context, page.sets[row], data, page),
                  ),);
                  //Extra Bottom Row to add Values
                  if(col == page.sets[0].values.length) return Center(child: TextField(
                    decoration: InputDecoration.collapsed(hintText: '---'),
                    style: style,
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    textAlign: TextAlign.center,
                    onSubmitted: (text) {
                      double val = double.tryParse(text);
                      //Fill every Set with null to ensure same-length lists
                      if(val != null) {
                        for(var set in page.sets) {
                          if(set == page.sets[row]) set.addValue(val);
                          else set.addValue(null);
                        }
                      }
                    },
                  ),);
                  return Center(child: TextField(
                    decoration: InputDecoration.collapsed(hintText: '---'),
                    style: style,
                    keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    controller: controllers[row][col],
                    focusNode: nodes[row][col],
                    textAlign: TextAlign.center,
                    onSubmitted: (text) {
                      double val = double.tryParse(text);
                      if(val != null) {
                        page.sets[row].setValue(col, val);
                        controllers[row][col].text = val.toString();
                      }
                      //Try to focus gridcell beneath
                      if(nodes[row].length > col) {
                        nodes[row][col+1].requestFocus();
                      }
                    },
                  ),);
                },
                childCount: page.sets.length*(page.sets[0].values.length+2)
            ),
          );
        }
        return SliverList(delegate: SliverChildListDelegate([
          Container(
            height: 200,
            child: Center(child: Text('Nothing here', style: TextStyle(color: data.textColor, fontSize: 20),),),
          )
        ]),);
      },
    );
  }

  void makeControllers(int sets, int vals, LoggrPage page) {
    //Generate Top Lists
    for(int i=controllers.length; i<sets; i++) {
      controllers.add(List<TextEditingController>());
      nodes.add(List<FocusNode>());
    }
    //Generate Text Editing Controllers
    for(int i=0; i<sets; i++) {
      for(int j=controllers[i].length; j<vals; j++) {
        //Show actual values
        double val = page.sets[i].values[j];
        String text = val == null ? '' : val.toString();
        controllers[i].add(TextEditingController(text: text));
        nodes[i].add(FocusNode());
      }
    }
  }
}