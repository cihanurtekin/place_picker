import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:place_picker/src/model/city.dart';
import 'package:place_picker/src/helper/paths.dart';
import 'package:place_picker/src/model/district.dart';

class CityPickerService {
  Map<String, dynamic>? _citesMap;

  Map<String, dynamic>? get citiesMap => _citesMap;

  String _defaultFileName = "turkey_districts.json";

  Map<String, City> _cities = Map<String, City>();

  Map<String, City> get cities => _cities;

  late String _countryCode;

  String get countryCode => _countryCode;

  CityPickerService(String countryCode) {
    _countryCode = countryCode;
    loadAllCities();
  }

  Future<void> _loadCitiesFromJsonFile() async {
    try {
      String jsonString = await rootBundle
          .loadString('${Paths.RESOURCES}/json/${_getFileNameByCountryCode()}');
      _citesMap = json.decode(jsonString);
    } catch (e) {
      print("CityPicker / _loadCitiesFromJsonFile : ${e.toString()}");
    }
  }

  String _getFileNameByCountryCode() {
    if (_countryCode == "TR") {
      return "turkey_districts.json";
    } else {
      return _defaultFileName;
    }
  }

  bool isReady() {
    return citiesMap != null;
  }

  Future<void> loadAllCities() async {
    if (citiesMap == null) {
      await _loadCitiesFromJsonFile();
    }
    try {
      _cities = Map<String, City>();
      citiesMap?.forEach((cKey, cValue) {
        Map<String, dynamic> cityMap = citiesMap?[cKey];
        Map<String, dynamic> districtsMap = cityMap['districts'];
        List<District> districts = [];
        districtsMap.forEach((dKey, dValue) {
          districts.add(District.fromMap(dKey, dValue));
        });
        City city = City.fromMap(cKey, cityMap);
        city.districts = districts;
        _cities[city.code] = city;
      });
    } catch (e) {
      print("CityPickerService / loadAllCities : ${e.toString()}");
      return null;
    }
  }
}
