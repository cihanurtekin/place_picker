import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:place_picker/src/model/city.dart';
import 'package:place_picker/src/model/country.dart';
import 'package:place_picker/src/model/district.dart';
import 'package:place_picker/src/model/place.dart';
import 'package:place_picker/src/service/city_picker_service.dart';
import 'package:place_picker/src/service/country_picker_service.dart';
import 'package:place_picker/src/view/city_picker_dialog.dart';
import 'package:place_picker/src/view/country_picker_dialog.dart';
import 'package:place_picker/src/view/district_picker_dialog.dart';

enum PlacePickerType { Country, City, District }

class PlacePicker {
  PlacePickerType _pickerType = PlacePickerType.Country;

  late CountryPickerService _countryPickerService;
  late CityPickerService _cityPickerService;

  late String _cityCodeForDistrictPicker;

  late String _defaultPhoneCode;
  late double _flagIconSize;

  late double _separatorHeight;
  late Color _separatorColor;

  PlacePicker.country({
    String defaultPhoneCode = "+1",
    double flagIconSize = 36.0,
    double separatorHeight = 1.0,
    Color separatorColor = Colors.grey,
  }) {
    _pickerType = PlacePickerType.Country;
    _defaultPhoneCode = defaultPhoneCode;
    _flagIconSize = flagIconSize;
    _separatorHeight = separatorHeight;
    _separatorColor = separatorColor;

    _countryPickerService = CountryPickerService();
  }

  PlacePicker.city(
    String countryCode, {
    double separatorHeight = 1.0,
    Color separatorColor = Colors.grey,
  }) {
    _pickerType = PlacePickerType.City;
    _separatorHeight = separatorHeight;
    _separatorColor = separatorColor;

    _cityPickerService = CityPickerService(countryCode);
  }

  PlacePicker.district(
    String countryCode,
    String cityCode, {
    double separatorHeight = 1.0,
    Color separatorColor = Colors.grey,
  }) {
    _pickerType = PlacePickerType.District;
    _separatorHeight = separatorHeight;
    _separatorColor = separatorColor;

    _cityCodeForDistrictPicker = cityCode;

    _cityPickerService = CityPickerService(countryCode);
  }

  Future<Place?> show(BuildContext context) async {
    if (_pickerType == PlacePickerType.Country) {
      return await _prepareCountryPickerDialog(context);
    } else if (_pickerType == PlacePickerType.City) {
      return await _prepareCityPickerDialog(context);
    } else if (_pickerType == PlacePickerType.District) {
      return await _prepareDistrictPickerDialog(context);
    } else {
      return null;
    }
  }

  Future<Country?> _prepareCountryPickerDialog(BuildContext context) async {
    if (!_countryPickerService.isReady()) {
      await _countryPickerService.loadAllCountries();
    }
    if (_countryPickerService.isReady()) {
      CountryPickerDialog countryPickerDialog = CountryPickerDialog(
        _countryPickerService.countries.values.toList(),
        defaultPhoneCode: _defaultPhoneCode,
        flagIconSize: _flagIconSize,
        separatorHeight: _separatorHeight,
        separatorColor: _separatorColor,
      );
      return _showCountryPickerDialog(context, countryPickerDialog);
    } else {
      return null;
    }
  }

  Future<City?> _prepareCityPickerDialog(BuildContext context) async {
    if (!_cityPickerService.isReady()) {
      await _cityPickerService.loadAllCities();
    }
    if (_cityPickerService.isReady()) {
      CityPickerDialog cityPickerDialog = CityPickerDialog(
          _cityPickerService.cities.values.toList(),
          separatorHeight: _separatorHeight,
          separatorColor: _separatorColor);
      return _showCityPickerDialog(context, cityPickerDialog);
    } else {
      return null;
    }
  }

  Future<District?> _prepareDistrictPickerDialog(BuildContext context) async {
    if (!_cityPickerService.isReady()) {
      await _cityPickerService.loadAllCities();
    }
    if (_cityPickerService.isReady()) {
      DistrictPickerDialog districtPickerDialog = DistrictPickerDialog(
        _cityPickerService.cities[_cityCodeForDistrictPicker]?.districts ?? [],
        separatorHeight: _separatorHeight,
        separatorColor: _separatorColor,
      );
      return _showDistrictPickerDialog(context, districtPickerDialog);
    } else {
      return null;
    }
  }

  Future<Country?> _showCountryPickerDialog(
      BuildContext context, CountryPickerDialog countryPickerDialog) {
    return showDialog<Country>(
      context: context,
      builder: (context) => countryPickerDialog,
    );
  }

  Future<City?> _showCityPickerDialog(
      BuildContext context, CityPickerDialog cityPickerDialog) {
    return showDialog<City>(
      context: context,
      builder: (context) => cityPickerDialog,
    );
  }

  Future<District?> _showDistrictPickerDialog(
      BuildContext context, DistrictPickerDialog districtPickerDialog) {
    return showDialog<District>(
      context: context,
      builder: (context) => districtPickerDialog,
    );
  }

  // SPECIAL COUNTRY METHODS

  Future<Country?> getCountryByCountryCode(String countryCode) async {
    if (!_countryPickerService.isReady()) {
      await _countryPickerService.loadAllCountries();
    }
    if (_countryPickerService.isReady()) {
      return _countryPickerService.countries[countryCode];
    } else {
      return null;
    }
  }

  Future<Country?> getCountryByPhoneCode(String phoneCode) async {
    if (!_countryPickerService.isReady()) {
      await _countryPickerService.loadAllCountries();
    }
    if (_countryPickerService.isReady()) {
      List<Country> allCountries =
          _countryPickerService.countries.values.toList();
      return allCountries.firstWhere((c) {
        return c.phoneCode == phoneCode;
      });
    } else {
      return null;
    }
  }

  Future<City?> getCityByCode(String cityCode) async {
    if (!_cityPickerService.isReady()) {
      await _cityPickerService.loadAllCities();
    }
    if (_cityPickerService.isReady()) {
      return _cityPickerService.cities[cityCode];
    } else {
      return null;
    }
  }

  Future<City?> getCityByName(String cityName) async {
    List<City> allCities = await _getAllCities();
    if (allCities.isNotEmpty) {
      return allCities.firstWhereOrNull((c) {
        return c.name.toLowerCase() == cityName.toLowerCase();
      });
    }
  }

  Future<District?> getDistrictByCode(String districtCode) async {
    return _cityPickerService.cities[_cityCodeForDistrictPicker]?.districts
        .firstWhereOrNull((d) {
      return d.code.toLowerCase() == districtCode.toLowerCase();
    });
  }

  Future<List<City>> _getAllCities() async {
    List<City> result = [];
    try {
      if (!_cityPickerService.isReady()) {
        await _cityPickerService.loadAllCities();
      }
      if (_cityPickerService.isReady()) {
        List<City> allCities = _cityPickerService.cities.values.toList();
        result.addAll(allCities);
      }
    } catch (e) {
      debugPrint('PlacePicker / _getAllCities: ${e.toString()}');
    }
    return result;
  }
}
