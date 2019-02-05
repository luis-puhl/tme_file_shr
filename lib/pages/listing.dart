import 'package:flutter/material.dart';

class Listing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [1, 2, 3].map((g) => ListTile(title: Text(g.toString()))),
        ).toList()
      ),
    );
  }
}