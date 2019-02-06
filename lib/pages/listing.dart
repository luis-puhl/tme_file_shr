import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/models.dart';

class Listing extends StatelessWidget {
  List<Widget> _buildCards(BuildContext context, List<Order> orders) {
    List<Widget> cards = [];
    for (var order in orders) {
      List<Widget> buttons = [];
      if (order.status == OrderStatus.local) {
        buttons = [
          FlatButton.icon(
            icon: Icon(Icons.edit),
            label: const Text('Editar'),
            onPressed: () => Navigator.pushNamed(context, '/edit/${order.id}'),
          ),
          ScopedModelDescendant<User>(
            builder: (context, child, model) => FlatButton.icon(
              icon: Icon(Icons.send),
              label: const Text('Enviar'),
              onPressed: () {
                model.orders.firstWhere((os) => os.id == order.id).status = OrderStatus.uploaded;
              },
            ),
          ),
        ];
      }
      cards.add(
        ListTile(
          title: Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.insert_drive_file),
                    title: Text(order.toString()),
                    subtitle: Text(order.toLongSting()),
                  ),
                  ButtonTheme.bar(
                    // make buttons use the appropriate styles for cards
                    child: ButtonBar(
                      children: buttons,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (context, child, model) => Scaffold(
        appBar: AppBar(
          title: Text(TelegramFileShareApp.title),
        ),
        body: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: _buildCards(context, model.orders),
          ).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/add'),
          tooltip: 'Nova Impressão',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
