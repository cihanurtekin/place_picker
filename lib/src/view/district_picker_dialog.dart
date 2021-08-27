import 'package:flutter/material.dart';
import 'package:place_picker/src/model/district.dart';

class DistrictPickerDialog extends StatelessWidget {
  final List<District> districts;
  final double separatorHeight;
  final Color separatorColor;

  DistrictPickerDialog(
    this.districts, {
    this.separatorHeight = 1.0,
    this.separatorColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemBuilder: _buildListViewItem,
              itemCount: districts.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListViewItem(BuildContext context, int index) {
    District district = districts[index];
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            district.name,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.pop(context, district);
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
