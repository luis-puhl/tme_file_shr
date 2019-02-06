import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final title = 'Causando Impressão';

  formNamePhone(context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
            icon: Icon(Icons.person),
            hintText: 'What do people call you?',
            labelText: 'Nome *',
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
          decoration: const InputDecoration(
            icon: Icon(Icons.phone),
            hintText: 'What do people call you?',
            labelText: 'Telefone *',
          ),
          onSaved: (String value) {
            // This optional block of code can be used to run
            // code when the user saves the form.
          },
          validator: (String value) {
            return value.contains('@') ? 'Do not use the @ char.' : null;
          },
        ),
        InputDecorator (
          decoration: const InputDecoration(
            icon: Icon(Icons.business),
            labelText: 'Loja *',
          ),
          child: DropdownButton(
            value: lojaStr[Loja.loja1],
            onChanged: (l) => print(l),
            items: lojaStr.values.map((str) => DropdownMenuItem<String>(
              child: Text(str),
              value: str,
            )).toList(),
          ),
        ),
        InputDecorator (
          decoration: const InputDecoration(
            icon: Icon(Icons.calendar_today),
            labelText: 'Data Retirada',
          ),
          child: FlatButton(
            child: Text(DateTime.now().toString()),
            onPressed: () async {
              final DateTime picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(Duration(days: 3)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101)
              );
              print(picked);
            },
          ),
        ),
        Center(
          child: Text('showDatePicker'),
        ),
      ],
    );
  }

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
              formNamePhone(context),
              Text('Passo 2'),
            ],
          ),
        ),
      ),
    );
  }
}
