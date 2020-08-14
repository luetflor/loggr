import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Data/LoggrData.dart';
import 'PageSelector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoggrData.load(),
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
