import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrData.dart';
import 'Data/LoggrPage.dart';
import 'PageSelector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoggrData.valued([
        LoggrPage('Hallo'),
        LoggrPage('Hallo Welt'),
        LoggrPage('Hallo du Welt')
      ]),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Loggr',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          backgroundColor: Colors.grey[300],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PageSelector(),
      ),
    );
  }
}
