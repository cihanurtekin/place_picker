import 'package:place_picker/src/model/district.dart';
import 'package:place_picker/src/model/place.dart';

class City extends Place {
  late String _name;
  late String _code;
  List<District> _districts = [];

  String get name => _name;

  String get code => _code;

  List<District> get districts => _districts;

  set districts(List<District> value) {
    _districts = value;
  }

  City({name = "Adana", code = "01", districts}) {
    this._name = name;
    this._code = code;
    this._districts = _districts;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this._name,
      'code': this._code,
      'districts': this._districts,
    };
  }

  City.fromMap(String code, Map<String, dynamic> map) {
    this._name = map['name'];
    this._code = code;
  }

  @override
  String toString() {
    String districts = "[";
    for (District d in this._districts) {
      districts += d.code + ": " + d.name + ", ";
    }
    districts += "]";

    return 'City{_name: $_name, _code: $_code, _districts: $districts}';
  }
}
