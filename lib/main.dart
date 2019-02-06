import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/id-form.dart';

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
