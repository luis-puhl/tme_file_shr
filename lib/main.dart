import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/id-form.dart';
import 'package:tme_file_shr/id-card.dart';
import 'package:tme_file_shr/add-group.dart';
import 'package:tme_file_shr/info.dart';

void main() {
  // You could optionally connect [model] with some database here.
  final model = Pedido();

  runApp(
    ScopedModel<Pedido>(
      model: model,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static final title = 'Foto Celula Express';

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
        '/info': (context) => Info(),
      },
      onGenerateRoute: (RouteSettings settings) {
        List<String> path = settings.name.split('/');
        switch (path[1]) {
          case 'group':
            int id = int.tryParse(path[2]);
            if (id != null) {
              return MaterialPageRoute(
                builder: (BuildContext _) => PrintGroup(id: id),
                settings: settings
              );
            }
            break;
          default:
        }
        return null;
      },
      home: IdentificationForm(),
    );
  }
}
