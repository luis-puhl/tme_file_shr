import 'package:flutter/material.dart';

class FormRadio<T> extends FormField<T> {
  final T initialValue, value1, value2;
  final Icon icon;
  final Widget key1, key2;
  final InputDecoration decoration;
  FormRadio({
    Key key,
    this.initialValue,
    this.value1,
    this.value2,
    this.icon,
    this.key1,
    this.key2,
    T value,
    this.onChanged,
    @required this.decoration,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    Widget hint,
  }): super(
    key: key,
    onSaved: onSaved,
    initialValue: initialValue,
    validator: validator,
    builder: (FormFieldState<T> field) {
      final InputDecoration effectiveDecoration = decoration.applyDefaults(Theme.of(field.context).inputDecorationTheme);
      return InputDecorator(
        decoration: effectiveDecoration.copyWith(errorText: field.errorText, ),
        isEmpty: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<T>(
                  value: value1,
                  groupValue: field.value,
                  onChanged: field.didChange,
                ),
                key1,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<T>(
                  value: value2,
                  groupValue: field.value,
                  onChanged: field.didChange,
                ),
                key2,
              ],
            ),
          ],
        ),
      );
    } // builder
  );

  /// Called when the user selects an item.
  final ValueChanged<T> onChanged;

  @override
  FormFieldState<T> createState() => _FormRadioState<T>();
}

class _FormRadioState<T> extends FormFieldState<T> {
  @override
  FormRadio<T> get widget => super.widget;

  @override
  void didChange(T value) {
    super.didChange(value);
    if (widget.onChanged != null)
      widget.onChanged(value);
  }
}