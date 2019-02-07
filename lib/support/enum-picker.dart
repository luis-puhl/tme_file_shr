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
    return InputDecorator(
      decoration: InputDecoration(
        icon: Icon(iconData),
        labelText: labelText,
        hintText: hintText,
        // contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 12),
      ),
      baseStyle: textStyle,
      isEmpty: originalValue == null,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          style: textStyle,
          isDense: true, // for InputDecorator
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
    );
  }
}
