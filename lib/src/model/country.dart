import 'package:place_picker/src/model/place.dart';
import 'package:place_picker/src/helper/paths.dart';

class Country extends Place {
  late String _name;
  late String _phoneCode;
  late String _code;
  late String _flag;

  String get name => _name;

  String get phoneCode => _phoneCode;

  String get code => _code;

  String get flag => _flag;

  Country({name = "Turkey", phoneCode = "+90", code = "TR"}) {
    this._name = name;
    this._phoneCode = phoneCode;
    this._code = code;
    this._flag = "${Paths.FLAGS_RECTANGULAR}/$code.png";
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this._name,
      'dial_code': this._phoneCode,
      'code': this._code,
      'flag': this._flag,
    };
  }

  Country.fromMap(Map<String, dynamic> map) {
    this._name = map['name'];
    this._phoneCode = map['dial_code'];
    this._code = map['code'];
    this._flag = "${Paths.FLAGS_RECTANGULAR}/${map['code']}.png";
  }

  @override
  String toString() {
    return 'Country{_name: $_name, _phoneCode: $_phoneCode, _code: $_code}';
  }


}