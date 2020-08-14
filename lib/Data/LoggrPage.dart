import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

enum LoadState {
  loading,
  empty,
  loaded
}
class LoggrPage extends ChangeNotifier
{
  LoadState _loading;

  String _title;
  List<DataSet> _sets;
  //TODO: Add Functions

  Function(String) nameChangedListener;

  //Creates empty page
  LoggrPage(String title, [LoadState isLoading = LoadState.empty]) {
    _title = title;
    _sets = List<DataSet>();
    _loading = isLoading;
  }

  @override
  void notifyListeners() {
    save();
    super.notifyListeners();
  }

  Future<void> save() async {
    //Save in Apps private document storage
    final appDir = await getApplicationDocumentsDirectory();
    Directory dir = Directory('${appDir.path}/pages/');
    dir.create(recursive: true);
    print(dir.path + title + '.json');
    File file = File(dir.path + title + '.json');
    String json = getAsJSON();
    print('Saving: \n' + json);
    file.writeAsString(json);
  }

  Future<void> load({Function onFinished}) async {
    _loading = LoadState.loading;
    final appDir = await getApplicationDocumentsDirectory();
    Directory dir = Directory('${appDir.path}/pages/');
    dir.create(recursive: true);
    File file = File(dir.path + title + '.json');
    String json = await file.readAsString();
    print('Loading: \n' + json);
    setFromJSON(json);
    _loading = LoadState.loaded;
    notifyListeners();
    if(onFinished != null) onFinished();
  }

  LoadState get loading => _loading;
  set loading(LoadState l) {
    _loading = l;
    notifyListeners();
  }

  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
    if(nameChangedListener != null) nameChangedListener(title);
  }

  List<DataSet> get sets => _sets;
  void addSet(DataSet set) {
    _sets.add(set);
    notifyListeners();
    //Carry over every data change notification to update graphs
    set.addListener(() => notifyListeners());
    //Fill List with null as all arrays should have same length
    if(_sets.length > 1) {
      while(set.values.length < _sets[0].values.length) {
        set.values.add(null);
      }
    }
  }
  void removeSet(DataSet set) {
    _sets.remove(set);
    notifyListeners();
  }

  List<DataSet> get inputs =>  _sets.where((element) => element.type == Type.Input).toList();
  List<DataSet> get outputs =>  _sets.where((element) => element.type == Type.Output).toList();

  Map<String, dynamic> getAsMap() {
    var setMap = List<Map<String, dynamic>>();
    for(var set in _sets) {
      setMap.add(set.getAsMap());
    }
    return {
      'title': _title,
      'sets': setMap
    };
  }
  setFromMap(Map<String, dynamic> map) {
    _title = map['title'];
    _sets = List<DataSet>();
    for(var set in map['sets']) {
      _sets.add(DataSet.mapped(set));
    }
  }

  String getAsJSON() {
    return jsonEncode(getAsMap());
  }
  setFromJSON(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    _title = map['title'];
    _sets = List<DataSet>();
    for(var set in map['sets']) {
      _sets.add(DataSet.mapped(set));
    }
  }
}


enum Type {
  Nothing,
  Input,
  Output
}
class DataSet extends ChangeNotifier
{
  String _name;
  Type _type = Type.Nothing;

  List<double> _values;

  DataSet(String name) {
    _name = name;
    _values = List<double>();
  }

  String get name => _name;
  set name(String n) {
    _name = n;
    notifyListeners();
  }

  Type get type => _type;
  set type(Type t) {
    _type = t;
    notifyListeners();
  }

  //Return a copy to not change existing values without notification
  List<double> get values => List.from(_values);
  void addValue(double v) {
    _values.add(v);
    notifyListeners();
  }
  void setValue(int index, double v) {
    _values[index] = v;
    notifyListeners();
  }

  Map<String, dynamic> getAsMap() {
    return {
      'type': _type.index,
      'name': _name,
      'values': _values
    };
  }
  DataSet.mapped(Map<String, dynamic> data) {
    _type = Type.values[data['type']];
    _name = data['name'];
    _values = List.castFrom(data['values']);
  }

}








