import 'package:flutter/material.dart';
import 'package:flutter/services.dart.';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/support/date-picker.dart';

class IdentificationForm extends StatefulWidget {
  @override
  _IdentificationFormState createState() => _IdentificationFormState();
}

class _IdentificationFormState extends State<IdentificationForm> {
  final _formKey = GlobalKey<FormState>();
  String _nome;
  String _telefone;
  String _loja = lojaStr[Loja.loja1];
  final DateTime minDataRetirada = DateTime.now().add(Duration(days: 3));
  DateTime _dataRetirada = DateTime.now().add(Duration(days: 3));
  final RegExp phoneExp = RegExp(r'[\d\-\ ]+');

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    final padding = SizedBox(height: 8.0);
    // const labelStyle = Theme.of(context).textTheme.title;
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
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
              if (value.isEmpty || value.trim().length < 4) {
                return 'Nome é obrigatório';
              }
              return null;
            },
          ),
          padding,
          TextFormField(
            style: valueStyle,
            keyboardType: TextInputType.phone,
            validator: (String value) {
              if (value.isEmpty) {
                return 'Telefone é obrigatório';
              }
              if (!phoneExp.hasMatch(value))
                return 'Número de telefone Inválido';
              return null;
            },
            decoration: const InputDecoration(
              icon: Icon(Icons.phone),
              labelText: 'Telefone',
              hintText: '11 9 1324-1234',
              prefixText: '+55 ',
            ),
            onSaved: (String value) { _telefone = value; },
          ),
          padding,
          InputDecorator(
            decoration: const InputDecoration(
              icon: Icon(Icons.business),
              labelText: 'Loja',
              hintText: 'Escolha uma loja para retirada',
              // contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 12),
            ),
            baseStyle: valueStyle,
            isEmpty: _loja == null,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                style: valueStyle,
                isDense: true, // for InputDecorator
                value: _loja,
                onChanged: (String newValue) => setState(() {
                  _loja = newValue;
                }),
                items: lojaStr.values.map((str) => DropdownMenuItem<String>(
                  child: Text(str, style: valueStyle),
                  value: str,
                )).toList(),
              ),
            ),
          ),
          padding,
          DateTimePicker(
            onlyDate: true,
            icon: Icon(Icons.calendar_today),
            labelText: 'Data Retirada',
            selectedDate: _dataRetirada,
            selectedTime: TimeOfDay.now(),
            selectDate: (DateTime date) {
              setState(() {
                _dataRetirada = date;
              });
            },
            selectTime: (TimeOfDay time) {},
            selectableDayPredicate: (DateTime date) => date.weekday != DateTime.sunday && date.weekday != DateTime.saturday && date.isAfter(minDataRetirada),
          ),
          padding,
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Enviado...')));
              }
            },
            child: Text('Evniar'),
          ),
        ],
      ),
    );
  }
}
