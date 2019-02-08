
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  final Icon icon;
  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: icon == null ? InputDecoration(
          labelText: labelText,
        ) : InputDecoration(
          icon: icon,
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
    this.onlyDate = false,
    this.icon,
    this.selectableDayPredicate,
  }) : super(key: key);

  final Icon icon;
  final bool onlyDate;
  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;
  final SelectableDayPredicate selectableDayPredicate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      selectableDayPredicate: selectableDayPredicate,
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime
    );
    if (picked != null && picked != selectedTime)
      selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> dateComp = <Widget>[
      Expanded(
        flex: 4,
        child: _InputDropdown(
          icon: icon,
          labelText: labelText,
          valueText: DateFormat.yMMMd().format(selectedDate),
          onPressed: () { _selectDate(context); },
        ),
      ),
    ];
    if (!onlyDate) {
      dateComp.addAll([
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            onPressed: () { _selectTime(context); },
          ),
        ),
      ]);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: dateComp,
    );
  }
}
