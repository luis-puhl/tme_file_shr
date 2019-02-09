import 'package:flutter/material.dart';

class EnumPicker<T> extends StatelessWidget {
  final IconData iconData;
  final String labelText;
  final String hintText;
  final TextStyle textStyle;
  final Map<T, String> map;
  final T originalValue;
  final Function onChanged;

  EnumPicker({
    Key key,
    this.iconData,
    this.labelText,
    this.hintText,
    this.textStyle,
    this.map,
    this.originalValue,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Icon(iconData),
        ),
        Expanded(
          child: DropdownButtonFormField<T>(
            // style: textStyle,
            // isDense: false, // for InputDecorator
            // isExpanded: true,
            value: originalValue,
            onChanged: onChanged,
            items: map.entries
                .map((mapEntry) => DropdownMenuItem<T>(
                      child: Text(mapEntry.value, style: textStyle),
                      value: mapEntry.key,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
