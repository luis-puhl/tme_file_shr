import 'package:flutter/material.dart';
import 'package:flutter/services.dart.';

import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/support/date-picker.dart';

class IdentificationForm extends StatefulWidget {
  @override
  _IdentificationFormState createState() => _IdentificationFormState();
}

class _IdentificationFormState extends State<IdentificationForm> {
  String _nome;
  String _telefone;
  Loja _lojaRetirada = Loja.loja1;
  DateTime _dataRetirada = nextValidDate(DateTime.now().add(Duration(days: 3)));

  final _formKey = GlobalKey<FormState>();
  static final DateTime minDataRetirada =
      nextValidDate(DateTime.now().add(Duration(days: 3)));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.pushNamed(context, '/info'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: TextFormField(
                textCapitalization: TextCapitalization.words,
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
              ),
            ),
            ListTile(
              title: TextFormField(
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
                onSaved: (String value) => setState(() {
                      _telefone = value;
                    }),
              ),
            ),
            Divider(),
            ListTile(
              title: FutureBuilder(
                future: Env.init(),
                builder: (context, snapshot) => DropdownButtonFormField<Loja>(
                  decoration: InputDecoration(
                    icon: Icon(Icons.business),
                    labelText: 'Loja',
                    hintText: 'Escolha uma loja para retirada',
                  ),
                  value: _lojaRetirada,
                  onSaved: (Loja newValue) => _lojaRetirada = newValue,
                  onChanged: (Loja newValue) =>
                      setState(() => _lojaRetirada = newValue),
                  items: (
                    Env.lojaStr != null ?
                    Env.lojaStr.entries
                    .map((MapEntry<Loja, LojaInfo> mapEntry) => DropdownMenuItem<Loja>(
                      child: Text(mapEntry.value.nome),
                      value: mapEntry.key,
                    ))
                    .toList()
                    :
                    [DropdownMenuItem<Loja>(
                      child: Text('Loja'),
                      value: Loja.loja1,
                    )]
                  ),
                ),
              ),
            ),
            ListTile(
              title: DateTimePicker(
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
              ),
            ),
            Divider(),
            ListTile(
              title: RaisedButton(
                onPressed: () {
                  _formKey.currentState.save();
                  if (_formKey.currentState.validate()) {
                    Pedido pedido = Pedido.of(context);
                    // Scaffold.of(context)
                    //     .showSnackBar(SnackBar(content: Text('Enviado...')));
                    pedido.setIdentification(_nome, '+55 ' + _telefone,
                        _lojaRetirada, _dataRetirada);
                    Navigator.pushNamed(context, '/pedido');
                  }
                },
                child: Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
