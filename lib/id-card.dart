import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/models.dart';

class IdentificationCard extends StatelessWidget {

  addGroup(context) {
    Navigator.pushNamed(context, '/group');
  }

  @override
  Widget build(BuildContext context) {
    if (Pedido.of(context).grupos == null || Pedido.of(context).grupos.length == 0) {
      Timer(new Duration(seconds: 1), () => addGroup(context));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addGroup(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
          Timer(new Duration(seconds: 1), () => Navigator.pushNamed(context, '/'));
          return Center(
            child: Text('Nothign to see'),
          );
        }
        return ListTile(
          leading: Icon(Icons.person, size: 50,),
          title: Text(model.nome),
          isThreeLine: true,
          subtitle: Text(model.toSubTitle()),
        );
      },
    );
  }
}
