import 'package:place_picker/src/model/place.dart';

class District extends Place{
  late String _name;
  late String _code;

  String get name => _name;

  String get code => _code;

  District({name = "Aladağ", code = "01_01"}) {
    this._name = name;
    this._code = code;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this._name,
      'code': this._code,
    };
  }

  District.fromMap(String code, Map<String, dynamic> map) {
    this._name = map['name'];
    this._code = code;
  }

  @override
  String toString() {
    return 'District{_name: $_name, _code: $_code}';
  }
}