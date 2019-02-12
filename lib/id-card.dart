import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tme_file_shr/main.dart';
import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/add-group.dart';
// import 'package:tme_file_shr/support/compute-patch.dart';

class IdentificationCard extends StatefulWidget {
  @override
  IdentificationCardState createState() {
    return new IdentificationCardState();
  }
}

class IdentificationCardState extends State<IdentificationCard> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.pushNamed(context, '/info'),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: HomeFab(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: _IdCard(
              pedido: pedido,
              isEmpty: (pedido == null ||
                  pedido.status == null ||
                  pedido.status == PedidoStatus.vazio ||
                  pedido.nome == null),
            ),
          ),
          Divider(),
        ]
            .followedBy(pedido.grupos.map((GrupoImpressao grupo) => ListTile(
                  title: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(
                              context, '/group/' + grupo.id.toString()),
                          child: ListTile(
                            leading: Icon(
                              (grupo.tipoGrupo == TipoGrupo.documento
                                  ? Icons.file_upload
                                  : Icons.photo_album),
                              size: 50,
                            ),
                            title: Text(grupo.arquivos.length.toString() +
                                (grupo.tipoGrupo == TipoGrupo.documento
                                    ? ' documentos'
                                    : ' fotos')),
                            isThreeLine: true,
                            subtitle: Text(grupo.toSubTitleString()),
                          ),
                        ),
                        ButtonTheme.bar(
                            padding: EdgeInsets.all(0),
                            child: ButtonBar(
                              alignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                IconButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  icon: Icon(Icons.delete),
                                  onPressed: () => setState(() => pedido.grupos
                                      .removeWhere((gr) => grupo.id == gr.id)),
                                ),
                                IconButton(
                                  color: Theme.of(context).colorScheme.primary,
                                  icon: Icon(Icons.edit),
                                  onPressed: () => Navigator.pushNamed(
                                      context, '/group/' + grupo.id.toString()),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                )))
            .toList(),
      ),
    );
  }
}

class _IdCard extends StatelessWidget {
  final Pedido pedido;
  final bool isEmpty;
  _IdCard({
    Key key,
    @required this.pedido,
    @required this.isEmpty,
  });

  Widget build(BuildContext context) {
    return Card(
      child: isEmpty
          ? Center(
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
                  subtitle:
                      Text(pedido.toSubTitle() + '\n' + pedido.statusString),
                ),
                ButtonTheme.bar(
                  child:
                      !Env.isDebuggin && (pedido.isEnviando || pedido.isEnviado)
                          ? ButtonBar(
                              alignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.done_all),
                                Text(pedido.statusString == null
                                    ? ''
                                    : pedido.statusString),
                              ],
                            )
                          : ButtonBar(
                              alignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FlatButton.icon(
                                  icon: Icon(Icons.edit),
                                  label: Text('Editar'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton.icon(
                                  icon: Icon(
                                    pedido.isEnviando
                                        ? Icons.update
                                        : Icons.playlist_add_check,
                                  ),
                                  label: Text('Finalizar Pedido'),
                                  textColor: Colors.amber.shade500,
                                  onPressed: () => _enviar(context),
                                ),
                              ],
                            ),
                ),
              ],
            ),
    );
  }
  _enviar(BuildContext context) async {
    ScaffoldState scaffold = Scaffold.of(context);
    if (pedido.isEnviando || pedido.isEnviado) {
      scaffold
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Pedido já enviado'))
        );
      return;
    }
    if (pedido.grupos.isEmpty) {
      scaffold
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Selecione ao menos uma configuração'))
        );
      return;
    }
    if (pedido.grupos.singleWhere((g) => g.arquivos.isEmpty).arquivos.isEmpty) {
      scaffold
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Configuração sem arquivos é inválida'))
        );
      return;
    }
    await pedido.enviar();
  }
}

class HomeFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        Pedido pedido = Pedido.of(context);
        GrupoImpressao group = GrupoImpressao();
        pedido.addGrupo(group);
        GrupoImpressao result = await Navigator.push<GrupoImpressao>(
          context,
          MaterialPageRoute(
              builder: (context) => PrintGroup(
                    id: group.id,
                  )),
        );
        if (result == null || result.arquivos.isEmpty) {
          pedido.removeGrupo(group);
          Scaffold.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
                SnackBar(content: Text('Selecione ao menos um arquivo')));
          return;
        }
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(result.arquivos.length.toString() +
                (result.tipoGrupo == TipoGrupo.documento
                    ? ' documentos'
                    : ' fotos') +
                ' adicionados'),
          ));
      },
      tooltip: 'Adicionar Arquivos',
      child: Icon(Icons.add),
    );
  }
}
