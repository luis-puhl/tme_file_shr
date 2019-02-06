import 'package:flutter/material.dart';

import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/support/provider.dart';

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
          FlatButton.icon(
            icon: Icon(Icons.send),
            label: const Text('Enviar'),
            onPressed: () {
              final User user = Provider.of(context).value;
              user.orders.firstWhere((os) => os.id == order.id).status = OrderStatus.uploaded;
              Provider.of(context).value = user;
            },
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
    final User user = Provider.of(context).value;
    print(user);
    final tiles = _buildCards(context, user.orders);
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
