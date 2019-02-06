import 'package:flutter/material.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/support/provider.dart';
import 'package:tme_file_shr/pages/landing.dart';
import 'package:tme_file_shr/pages/listing.dart';
import 'package:tme_file_shr/pages/add_file.dart';

void main() => runApp(TelegramFileShareApp());

class TelegramFileShareApp extends StatelessWidget {
  static final title = 'Causando Impressão';
  @override
  Widget build(BuildContext context) {
    return Provider(
      initialValue: User(),
      child: MaterialApp(
        title: title,
        home: Landing(),
        routes: <String, WidgetBuilder>{
          '/landing': (BuildContext context) => Landing(),
          '/listing': (BuildContext context) => Listing(),
          '/add': (BuildContext context) => AddFile(),
        },
        onGenerateRoute: (RouteSettings settings) {
          // Split up the path
          final List<String> path = settings.name.split('/');
          // First entry should be empty as all paths should start with a '/'
          assert(path[0] == '');
          // Only valid path is '/second/<double value>'
          if (path[1] == 'edit' && path.length == 3) {
            final id = int.parse(path[2]);

            return MaterialPageRoute<double>(
              settings: settings,
              builder: (BuildContext context) => AddFile(id: id),
            );
          }
          // The other paths we support are in the routes table.
          return null;
        },
      ),
    );
  }
}
