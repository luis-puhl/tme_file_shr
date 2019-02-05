import 'package:flutter/material.dart';

import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/support/provider.dart';

class Listing extends StatelessWidget {
  List<Widget> _buildCards() {
    return [
      'Queen!',
      'Man at work',
      'Midnight Oil',
    ]
        .map((String g) => ListTile(
              title: Center(
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.album),
                        title: Text(g),
                        subtitle: Text(
                            'Music by Julie Gable. Lyrics by Sidney Stein.'),
                      ),
                      ButtonTheme.bar(
                        // make buttons use the appropriate styles for cards
                        child: ButtonBar(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('BUY TICKETS'),
                              onPressed: () {/* ... */},
                            ),
                            FlatButton(
                              child: const Text('LISTEN'),
                              onPressed: () {/* ... */},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of(context).value;
    print(user);
    final tiles = _buildCards();
    // tiles.add(Text(user.name));
    return Scaffold(
      appBar: AppBar(
        title: Text(TelegramFileShareApp.title),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        tooltip: 'Nova Impressão',
        child: Icon(Icons.add),
      ),
    );
  }
}
