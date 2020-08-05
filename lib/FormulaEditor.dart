import 'package:flutter/material.dart';
import 'package:loggr/Design.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrData.dart';

const List<String> mains = [
  'shift', 'menu', null, 'back', 'AC',
  'π', 'sin', 'cos', 'tan', 'i',
  'x²', '√x', 'log', 'ln', 'e',
  '7', '8', '9', '(', ')',
  '4', '5', '6', 'x', '÷',
  '1', '2', '3', '+', '-',
  ',', '0', '+/-', '10^x', '='
];

const Map<String, String> alt = {
  'sin': 'arcsin',
  'cos': 'arccos',
  'tan': 'arctan',
  'ln': 'log2',
  'x²': 'x^y',
  '√x': 'y√x'
};

class FormulaEditor extends StatefulWidget
{
  final String title;

  const FormulaEditor({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormulaEditorState();
  }

}

class FormulaEditorState extends State<FormulaEditor>
{
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<LoggrData>(context);
    double size = 55;
    double margin = 7;
    return Scaffold(
      backgroundColor: data.background,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: data.textColor),),
        iconTheme: IconThemeData(color: data.textColor),
        backgroundColor: data.background,
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          //Viewing Area
          Expanded(child: Container(),),

          //Buttons
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            physics: NeverScrollableScrollPhysics(),
            children: mains.map<Widget>(
                (content) {
                  if(content is String) {
                    if(content == 'AC') return getButton(data, content, color: Color(0xffbc2a27));
                    if(content == 'back') return getButtonIcon(data, Icons.backspace, color: Color(0xffbc2a27));
                    return getButton(data, content, alt: alt[content]);
                  }
                  return Container();
                }
            ).toList(),
          ),
        ],),
      ),
    );
  }

  Widget getButton(LoggrData data, String text, {Color color, double size = 55, double margin = 7, String alt}) {
    Widget child = Text(text, style: TextStyle(fontSize: 17),);
    if(alt != null) {
      child = Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[child, Text(alt, style: TextStyle(color: data.backgroundAlt, fontSize: 12),)],
      );
    }
    return SurfaceSwitch(false,
        width: size, height: size,
        margin: EdgeInsets.all(margin),
        color: color,
        child: Center(child: child,),
        onPress: () {},
    );
  }

  Widget getButtonIcon(LoggrData data, IconData icon, {Color color, double size = 55, double margin = 7}) {
    return SurfaceSwitch(false,
      width: size, height: size,
      margin: EdgeInsets.all(margin),
      color: color,
      child: Center(child: Icon(icon),),
      onPress: () {},
    );
  }
}