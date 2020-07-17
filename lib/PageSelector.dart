import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:loggr/Design.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrPage.dart';

class PageSelector extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return PageSelectorState();
  }
}

class PageSelectorState extends State<PageSelector>
{
  LoggrData data;

  @override
  void initState() {
    //TODO: Actually load Data
    data = LoggrData.valued([
      LoggrPage('Hallo'),
      LoggrPage('Hallo Welt'),
      LoggrPage('Hallo du Welt')
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaf = Scaffold(
      backgroundColor: data.background,
      floatingActionButton: AddFAB(onSubmit: (name) => setState(() {
        var page = LoggrPage(name.trim());
        data.addPage(page);
      }),),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: data.background,
            flexibleSpace: Center(child: Text('Pages', style: TextStyle(color: data.textColor, fontSize: 40),),),
            expandedHeight: 300,
          ),
          SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(child: Text(data.pages[index].title, style: TextStyle(fontSize: 25, color: data.textColor), textAlign: TextAlign.start,),
                    onPressed: () {}, //Open Page
                    onLongPress: () => showBottomSheet(context, data.pages[index], data), //Show Page Settings
                  ),
                );
              },
              childCount: data.pages.length
          ),)
        ],
      ),
    );
    return ChangeNotifierProvider<LoggrData>.value(
      value: data,
      child: scaf,
    );
  }

  void showBottomSheet(BuildContext context, LoggrPage page, LoggrData data) {
    showModalBottomSheet(backgroundColor: data.background, context: context, builder: (context) {
      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(height: 10,),
        getModalButton(context, 'Rename', () {}),
        getModalButton(context, 'Delete', () => setState(() {
          data.removePage(page);
          Navigator.pop(context);
        }), color: Colors.redAccent),
        Container(height: 30,)
      ],);
    });
  }
}

Widget getModalButton(context, String text, onPress, {color}) {
  var col = color == null ? Colors.black : color;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    child: FlatButton(onPressed: () => onPress(), child: Text(text, style: TextStyle(fontSize: 25, color: col),)),
  );
}