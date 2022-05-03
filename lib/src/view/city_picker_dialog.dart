import 'package:flutter/material.dart';
import 'package:place_picker/src/model/city.dart';

class CityPickerDialog extends StatelessWidget {
  final List<City> cities;
  final double separatorHeight;
  final Color separatorColor;

  CityPickerDialog(
    this.cities, {
    this.separatorHeight = 1.0,
    this.separatorColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemBuilder: _buildListViewItem,
          itemCount: cities.length,
        ),
      ),
    );
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    City city = cities[index];
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            city.code + " - " + city.name,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.pop(context, city);
          },
        ),
        Container(
          height: separatorHeight,
          color: separatorColor,
        )
      ],
    );
  }
}
