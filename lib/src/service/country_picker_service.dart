import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:place_picker/src/model/country.dart';
import 'package:place_picker/src/helper/paths.dart';

class CountryPickerService {
  Map<String, dynamic>? _countriesMap;

  Map<String, dynamic>? get countriesMap => _countriesMap;

  Map<String, Country> _countries = Map<String, Country>();

  Map<String, Country> get countries => _countries;

  CountryPickerService() {
    loadAllCountries();
  }

  Future<void> _loadCountriesFromJsonFile() async {
    try {
      String jsonString =
          await rootBundle.loadString('${Paths.RESOURCES}/json/countries.json');
      _countriesMap = json.decode(jsonString);
    } catch (e) {
      print(
          "CountryPickerService / _loadCountriesFromJsonFile : ${e.toString()}");
    }
  }

  bool isReady() {
    return countriesMap != null;
  }

  Future<void> loadAllCountries() async {
    if (_countriesMap == null) {
      await _loadCountriesFromJsonFile();
    }
    try {
      _countries = Map<String, Country>();
      Iterable<dynamic> values = countriesMap?.values ?? [];
      for (Map<String, dynamic> cMap in values) {
        Country c = Country.fromMap(cMap);
        _countries[c.code] = c;
      }
    } catch (e) {
      print("CountryPickerService / loadAllCountries : ${e.toString()}");
    }
  }
}
