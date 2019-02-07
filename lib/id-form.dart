import 'package:flutter/material.dart';
import 'package:flutter/services.dart.';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/support/date-picker.dart';

class IdentificationForm extends StatefulWidget {
  @override
  _IdentificationFormState createState() => _IdentificationFormState();
}

class _IdentificationFormState extends State<IdentificationForm> {
  final _formKey = GlobalKey<FormState>();

  TextStyle valueStyle;
  String _nome;
  String _telefone;
  Loja _lojaRetirada = Loja.loja1;
  static final DateTime minDataRetirada =
      nextValidDate(DateTime.now().add(Duration(days: 3)));
  DateTime _dataRetirada = nextValidDate(DateTime.now().add(Duration(days: 3)));
  final RegExp phoneExp = RegExp(r'[\d\-\ ]+');

  static bool isValidDate(DateTime date) {
    return date.weekday != DateTime.sunday && date.weekday != DateTime.saturday;
  }

  static DateTime nextValidDate(DateTime date) {
    if (!isValidDate(date)) {
      return nextValidDate(date.add(Duration(days: 1)));
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    this.valueStyle = Theme.of(context).textTheme.title;
    final padding = SizedBox(height: 8.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            _nomeField(),
            padding,
            _telefoneField(),
            padding,
            _lojaPicker(),
            padding,
            _datePicker(),
            padding,
            ScopedModelDescendant<Pedido>(
              builder: (context, child, model) {
                return RaisedButton(
                  onPressed: () {
                    _formKey.currentState.save();
                    if (_formKey.currentState.validate()) {
                      // Scaffold.of(context)
                      //     .showSnackBar(SnackBar(content: Text('Enviado...')));
                      model.setIdentification(
                          _nome, '+55 ' + _telefone, _lojaRetirada, _dataRetirada);
                      Navigator.pushNamed(context, '/pedido');
                    }
                  },
                  child: Text('Evniar'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _datePicker() {
    return DateTimePicker(
      onlyDate: true,
      icon: Icon(Icons.calendar_today),
      labelText: 'Data Retirada',
      selectedDate: _dataRetirada,
      selectedTime: TimeOfDay.now(),
      selectDate: (DateTime date) => setState(() {
            _dataRetirada = date;
          }),
      selectTime: (TimeOfDay time) {},
      selectableDayPredicate: (DateTime date) =>
          isValidDate(date) &&
          date.isAfter(DateTime.now().add(Duration(days: 3))),
    );
  }

  _lojaPicker() {
    return InputDecorator(
      decoration: const InputDecoration(
        icon: Icon(Icons.business),
        labelText: 'Loja',
        hintText: 'Escolha uma loja para retirada',
        // contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 12),
      ),
      baseStyle: valueStyle,
      // isEmpty: _lojaRetirada == null,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Loja>(
          style: valueStyle,
          isDense: true, // for InputDecorator
          value: _lojaRetirada,
          onChanged: (Loja newValue) => setState(() {
                _lojaRetirada = newValue;
              }),
          items: lojaStr.entries
              .map((mapEntry) => DropdownMenuItem<Loja>(
                    child: Text(mapEntry.value, style: valueStyle),
                    value: mapEntry.key,
                  ))
              .toList(),
        ),
      ),
    );
  }

  _telefoneField() {
    return TextFormField(
      style: valueStyle,
      keyboardType: TextInputType.phone,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Telefone é obrigatório';
        }
        if (!phoneExp.hasMatch(value)) return 'Número de telefone Inválido';
        return null;
      },
      decoration: const InputDecoration(
        icon: Icon(Icons.phone),
        labelText: 'Telefone',
        hintText: '11 9 1324-1234',
        prefixText: '+55 ',
      ),
      onSaved: (String value) => setState(() {
            _telefone = value;
          }),
    );
  }

  _nomeField() {
    return TextFormField(
      style: valueStyle,
      decoration: const InputDecoration(
        icon: Icon(Icons.person),
        labelText: 'Nome',
      ),
      onSaved: (String value) => setState(() {
            _nome = value;
          }),
      validator: (String value) {
        if (value.isEmpty || value.trim().length < 4) {
          return 'Nome é obrigatório';
        }
        return null;
      },
    );
  }
}
