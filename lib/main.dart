import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/id-form.dart';

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
      },
      home: IdentificationForm(),
    );
  }
}

class IdentificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _pedidoCard(),
          ],
        ),
      ),
    );
  }

  _pedidoCard() {
    return ScopedModelDescendant<Pedido>(
      builder: (context, child, model) {
        if (model == null ||
            model.status == null ||
            model.status == PedidoStatus.vazio ||
            model.nome == null) {
          return Center(
            child: Text('Nothign to see'),
          );
          // Navigator.pushNamed(context, '/');
        }
        return ListTile(
          leading: Icon(Icons.person),
          title: Text(model.nome),
          isThreeLine: true,
          subtitle: Text(model.toSubTitle()),
        );
      },
    );
  }
}
