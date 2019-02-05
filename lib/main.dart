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
    return new Provider(
      initialValue: User(),
      child: MaterialApp(
        title: title,
        home: Landing(),
        routes: <String, WidgetBuilder>{
          '/landing': (BuildContext context) => Landing(),
          '/listing': (BuildContext context) => Listing(),
          '/add': (BuildContext context) => AddFile(),
        },
      ),
    );
  }
}
