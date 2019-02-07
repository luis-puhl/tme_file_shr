import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/id-form.dart';
import 'package:tme_file_shr/id-card.dart';
import 'package:tme_file_shr/add-group.dart';

void main() {
  final model = Pedido();

  // You could optionally connect [model] with some database here.

  runApp(
    ScopedModel<Pedido>(
      model: model,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final title = 'Causando Impressão';

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
      routes: {
        '/id': (context) => IdentificationForm(),
        '/pedido': (context) => IdentificationCard(),
        '/group': (context) => PrintGroup(),
      },
      home: IdentificationForm(),
    );
  }
}
