import 'package:flutter/material.dart';
import 'package:place_picker/src/model/country.dart';
import 'package:place_picker/src/helper/paths.dart';

class CountryPickerDialog extends StatefulWidget {
  final List<Country> allCountries;
  final String defaultPhoneCode;
  final double flagIconSize;
  final double separatorHeight;
  final Color separatorColor;

  CountryPickerDialog(
      this.allCountries, {
        this.defaultPhoneCode = "+1",
        this.flagIconSize = 36.0,
        this.separatorHeight = 1.0,
        this.separatorColor = Colors.grey,
      });

  @override
  _CountryPickerDialogState createState() => _CountryPickerDialogState();
}

class _CountryPickerDialogState extends State<CountryPickerDialog> {
  TextEditingController _textEditingController = TextEditingController();

  List<Country> _filteredCountries = [];

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _filteredCountries.addAll(widget.allCountries);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: <Widget>[
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: "Ülke Adı Girin",
            ),
            onChanged: _onSearchTextFieldChanged,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: _buildListViewItem,
              itemCount: _filteredCountries.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    Country country = _filteredCountries[index];
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            country.name,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(country.phoneCode),
          leading: _getCountryFlag(country.code),
          onTap: () {
            Navigator.pop(context, country);
          },
        ),
        Container(
          height: widget.separatorHeight,
          color: widget.separatorColor,
        )
      ],
    );
  }

  _onSearchTextFieldChanged(String value) {
    setState(() {
      _filteredCountries = widget.allCountries
          .where((c) => c.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Widget _getCountryFlag(String countryCode) {
    Image image;
    try {
      image = Image.asset(
        "${Paths.FLAGS_RECTANGULAR}/$countryCode.png",
        height: widget.flagIconSize,
      );
      return image;
    } catch (e) {
      print("CountryPickerDialog / _getCountryFlag : ${e.toString()}");
      return Container(
        color: Colors.white,
        height: widget.flagIconSize,
      );
    }
  }


}
