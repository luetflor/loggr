import 'package:flutter/cupertino.dart';

class LoggrPage extends ChangeNotifier
{
  bool _loading = false;

  String _title;
  List<DataSet> _sets;
  //TODO: Add Functions

  Function(String) nameChangedListener;

  //Creates empty page
  LoggrPage(String title) {
    _title = title;
    _sets = List<DataSet>();
  }

  bool get loading => _loading;
  set loading(bool l) {
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
  }
  void removeSet(DataSet set) {
    _sets.remove(set);
    notifyListeners();
  }

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
  LoggrPage.mapped(Map<String, dynamic> map) {
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

  List<double> get values => _values;
  void addValue(double v) {
    _values.add(v);
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
    _values = data['values'];
  }

}








