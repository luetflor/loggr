import 'package:flutter/material.dart';

import 'PageSelector.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loggr',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        backgroundColor: Colors.grey[300],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageSelector(),
    );
  }
}
