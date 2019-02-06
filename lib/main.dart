import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import 'package:tme_file_shr/models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final title = 'Causando Impressão';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      // theme: ThemeData.dark(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('pt', ''),
      ],
      home: ScopedModel<Pedido>(
        model: Pedido(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              IdentificationForm(),
              Text('Passo 2'),
            ],
          ),
        ),
      ),
    );
  }
}

class IdentificationForm extends StatefulWidget {
  @override
  _IdentificationFormState createState() => _IdentificationFormState();
}

class _IdentificationFormState extends State<IdentificationForm> {
  DateTime _fromDate = DateTime.now().add(Duration(days: 3));
  String _loja = lojaStr[Loja.loja1];

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          style: valueStyle,
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            labelText: 'Nome',
          ),
          onSaved: (String value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String value) {
            return value.contains('@') ? 'Do not use the @ char.' : null;
          },
        ),
        TextFormField(
          style: valueStyle,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            icon: Icon(Icons.phone),
            labelText: 'Telefone',
          ),
        ),
        InputDecorator(
          baseStyle: valueStyle,
          decoration: const InputDecoration(
            icon: Icon(Icons.business),
            labelText: 'Loja',
            hintText: 'Escolha uma loja para retirada',
            contentPadding: EdgeInsets.zero,
          ),
          isEmpty: _loja == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              style: valueStyle,
              isExpanded: true,
              value: _loja,
              onChanged: (String newValue) {
                setState(() {
                  _loja = newValue;
                });
              },
              items: lojaStr.values.map((str) => DropdownMenuItem<String>(
                child: Text(str, style: valueStyle),
                value: str,
              )).toList(),
            ),
          ),
        ),
        _DateTimePicker(
          onlyDate: true,
          icon: Icon(Icons.calendar_today),
          labelText: 'Data Retirada',
          selectedDate: _fromDate,
          selectedTime: TimeOfDay.now(),
          selectDate: (DateTime date) {
            setState(() {
              _fromDate = date;
            });
          },
          selectTime: (TimeOfDay time) {},
        ),
      ],
    );
  }
}

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

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
    this.onlyDate = false,
    this.icon,
  }) : super(key: key);

  final Icon icon;
  final bool onlyDate;
  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
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
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    final List<Widget> dateComp = <Widget>[
      Expanded(
        flex: 4,
        child: _InputDropdown(
          icon: icon,
          labelText: labelText,
          valueText: DateFormat.yMMMd().format(selectedDate),
          valueStyle: valueStyle,
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
            valueStyle: valueStyle,
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
