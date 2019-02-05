import 'package:flutter/material.dart';

import 'package:tme_file_shr/pages/landing.dart';
import 'package:tme_file_shr/pages/listing.dart';
import 'package:tme_file_shr/pages/add_file.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: Landing(),
      routes: <String, WidgetBuilder>{
        '/listing': (BuildContext context) => Listing(),
        '/add': (BuildContext context) => AddFile(),
      },
    );
  }
}
