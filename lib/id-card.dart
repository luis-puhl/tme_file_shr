import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/models.dart';

class IdentificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<Pedido>(
      builder: (context, child, model) {
        var scaffold = this.buildStaless(context, model);
        return scaffold;
      },
    );
  }

  Widget buildStaless(BuildContext context, Pedido pedido) {
    bool isEmpty = (pedido == null || pedido.status == null || pedido.status == PedidoStatus.vazio || pedido.nome == null);
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.pushNamed(context, '/group');
          GrupoImpressao grupo;
          if (result is! GrupoImpressao) {
            return;
          } else {
            grupo = result;
          }
          try {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(grupo.arquivos.length.toString() + (grupo.tipoGrupo == TipoGrupo.documento ? ' documentos' : ' fotos') + ' adicionados'),
              ));
          } catch (e) {
          }
        },
        tooltip: 'Adicionar Arquivos',
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Card(
              child: isEmpty ?
                Center(
                  child: Text('Nenum Pedido'),
                )
                : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 50,
                    ),
                    title: Text(pedido.nome),
                    isThreeLine: true,
                    subtitle: Text(pedido.toSubTitle() + '\n' + pedido.statusString),
                  ),
                  ButtonTheme.bar(
                    child: pedido.isEnviando || pedido.isEnviado ?
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.done_all),
                        Text(pedido.statusString == null ? '' : pedido.statusString),
                      ],
                    )
                    :
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton.icon(
                          icon: Icon(Icons.edit),
                          label: Text('Editar'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FlatButton.icon(
                          icon: Icon(
                            pedido.isEnviando ? Icons.update: Icons.playlist_add_check,
                          ),
                          label: Text('Finalizar Pedido'),
                          textColor: Colors.amber.shade500,
                          onPressed: () async {
                            if (pedido.isEnviando || pedido.isEnviado) return;
                            await pedido.enviar();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ]
        .followedBy(
          pedido.grupos.map((GrupoImpressao grupo) => ListTile(
            title: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      (grupo.tipoGrupo == TipoGrupo.documento ? Icons.file_upload : Icons.photo_album),
                      size: 50,
                    ),
                    title: Text(grupo.arquivos.length.toString() + (grupo.tipoGrupo == TipoGrupo.documento ? ' documentos' : ' fotos')),
                    isThreeLine: true,
                    subtitle: Text(grupo.toSubTitleString()),
                    trailing: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: IconButton(
                        color: Theme.of(context).colorScheme.primary,
                        icon: Icon(Icons.edit),
                        onPressed: () => Navigator.pushNamed(context, '/group/' + grupo.id.toString()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))
        )
        .toList()
        ,
      ),
    );
  }
}
