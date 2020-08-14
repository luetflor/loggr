import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'LoggrPage.dart';

/*
 * Each Page should be saved in its own file
 * All other settings should be included in extra settings file
 */
class LoggrData extends ChangeNotifier
{
  //Const used for Data Loading
  bool _loading = false;

  List<LoggrPage> _pages;

  Color _background = Colors.grey[300];
  Color _backgroundAlt = Colors.grey[400];
  Color _accent = Colors.blueGrey;
  Color _textColor = Colors.black;

  LoggrData() {
    _pages = List<LoggrPage>();
  }

  LoggrData.load() {
    _loading = true;
    load();
  }

  LoggrData.valued(this._pages);

  Future<void> load() async {
    //Get Page Paths
    final appDir = await getApplicationDocumentsDirectory();
    Directory dir = Directory('${appDir.path}/pages/');
    dir.create(recursive: true);
    var files = dir.list(recursive: false);
    _pages = List<LoggrPage>();
    files.listen((FileSystemEntity entity) {
      String name = entity.path.replaceAll(entity.parent.path, '');
      name = name.replaceAll('/', '');
      name = name.replaceAll('\\', '');
      //Only add the actual json files
      if(name.contains('.json')) {
        name = name.replaceAll('.json', '');
        _pages.add(LoggrPage(name, LoadState.empty));
      }
    }, onDone: () {
      _loading = false;
      notifyListeners();
    });
  }

  bool get loading => _loading;
  set loading(bool l) {
    _loading = l;
    notifyListeners();
  }

  List<LoggrPage> get pages => _pages;
  void addPage(LoggrPage page) {
    _pages.add(page);
    notifyListeners();
  }
  void removePage(LoggrPage page) {
    _pages.remove(page);
    notifyListeners();
  }

  Color get background => _background;
  set background(Color bg) {
    _background = bg;
    notifyListeners();
  }

  Color get accent => _accent;
  set accent(Color acc) {
    _accent = acc;
    notifyListeners();
  }

  Color get textColor => _textColor;
  set textColor(Color txt) {
    _textColor = txt;
    notifyListeners();
  }

  Color get backgroundAlt => _backgroundAlt;
  set backgroundAlt(Color txt) {
    _backgroundAlt = txt;
    notifyListeners();
  }
}

