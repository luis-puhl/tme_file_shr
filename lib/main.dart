import 'package:flutter/material.dart';

import 'package:tme_file_shr/pages/landing.dart';
import 'package:tme_file_shr/pages/listing.dart';
import 'package:tme_file_shr/pages/add_file.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Causando Impressão',
      home: Landing(),
      routes: <String, WidgetBuilder>{
        '/landing': (BuildContext context) => Landing(),
        '/listing': (BuildContext context) => Listing(),
        '/add': (BuildContext context) => AddFile(),
      },
    );
  }
}
