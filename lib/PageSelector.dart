import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loggr/Data/LoggrData.dart';
import 'package:loggr/Design.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrPage.dart';
import 'DataViewingWidgets/PageViewer.dart';

class PageSelector extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Consumer<LoggrData>(
      builder: (context, data, _) {
        Widget list;
        if(data.loading) {
          list = SliverList(delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.all(50),
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(),
            )
          ]),);
        } else {
          list = SliverList(delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  alignment: AlignmentDirectional.topStart,
                  child: FlatButton(child: Text(data.pages[index].title, style: TextStyle(fontSize: 30, color: data.textColor, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PageViewer(data.pages[index])) ), //Open Page
                    onLongPress: () => showBottomSheet(context, data.pages[index], data), //Show Page Settings
                  ),
                );
              },
              childCount: data.pages.length
          ),);
        }

        return Scaffold(
          backgroundColor: data.background,
          floatingActionButton: AddFAB(onSubmit: (name) => addPage(name, data),),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: data.background,
                flexibleSpace: Center(child: Text('Pages', style: TextStyle(color: data.textColor, fontSize: 40),),),
                expandedHeight: 300,
              ),
              list
            ],
          ),
        );
      },
    );
  }

  void addPage(name, LoggrData data) {
    if(!name.contains('/') && !name.contains('\\') && !name.contains('.')) {
      LoggrPage page = LoggrPage(name, LoadState.loaded);
      data.addPage(page);
    }
  }

  void showBottomSheet(BuildContext context, LoggrPage page, LoggrData data) {
    showModalBottomSheet(backgroundColor: data.background, context: context, builder: (context) {
      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(height: 20,),
        getModalButton(context, 'Rename', () {}),
        getModalButton(context, 'Delete', () {
          data.removePage(page);
          Navigator.pop(context);
        }, color: Colors.redAccent),
        Container(height: 30,)
      ],);
    });
  }
}

Widget getModalButton(context, String text, onPress, {color}) {
  var col = color == null ? Colors.black : color;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
    child: FlatButton(onPressed: () => onPress(), child: Text(text, style: TextStyle(fontSize: 25, color: col),)),
  );
}