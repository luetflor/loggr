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
  @override
  Widget build(BuildContext context) {
    LoggrData data = Provider.of<LoggrData>(context);
    TextStyle style = TextStyle(color: data.textColor, fontSize: 20.0);
    return Consumer<LoggrPage>(
      builder: (context, page, child) {
        // Add a single child as a sliver
        double height = 50;
        double width = MediaQuery.of(context).size.width/page.sets.length;
        if(page.sets.length > 0) return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: page.sets.length, childAspectRatio: width/height),
          delegate: SliverChildBuilderDelegate(
              (context, index) {
                int col = (index/page.sets.length).floor()-1;
                int row = index%page.sets.length;
                if(col == -1)
                  return Center(child: GestureDetector(
                    child: Text(page.sets[row].name, style: style),
                    onLongPress: () => showSetModal(context, page.sets[row], data, page),
                  ),);
                double val = page.sets[row].values[col];
                String text = val == null ? '' : val.toString();
                return Center(child: TextField(
                  decoration: InputDecoration.collapsed(hintText: '---'),
                  style: style,
                  controller: TextEditingController(text: text),
                  textAlign: TextAlign.center,
                  onSubmitted: (text) {
                    double val = double.tryParse(text);
                    if(val != null) page.sets[row].setValue(col, val);
                  },
                ),);
              },
              childCount: page.sets.length*(page.sets[0].values.length+1)
          ),
        );
        return SliverList(delegate: SliverChildListDelegate([
          Container(
            height: 200,
            child: Center(child: Text('Nothing here', style: TextStyle(color: data.textColor, fontSize: 20),),),
          )
        ]),);
      },
    );
  }

}