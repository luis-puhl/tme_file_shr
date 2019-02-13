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
                                  onPressed: () async {
                                    await Navigator.push<GrupoImpressao>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PrintGroup(id: grupo.id)
                                      )
                                    );
                                  },
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
                  child: _buildButtonsIdCard(context),
                ),
              ],
            ),
    );
  }

  _buildButtonsIdCard(BuildContext context) {
    Widget doneBar = Column(
      children: <Widget>[
        ListTile(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.max,
          // children: <Widget>[
          leading: Padding(
            padding: EdgeInsets.all(16),
            child: Icon(Icons.done_all),
          ),
          title: Text(pedido.statusString ?? ''),
          dense: true,
          // ],
        ),
        pedido.isEnviado
          ? ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton.icon(
                  label: Text('Novo pedido'),
                  color: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: () {
                    startApp();
                    Navigator.pop(context);
                  },
                )
            ],
          )
          : Container(),
      ],
    );
    Widget editingBar = ButtonBar(
      alignment: MainAxisAlignment.end,
      children: <Widget>[
        FlatButton.icon(
          textColor: Theme.of(context).buttonTheme.colorScheme.primary,
          icon: Icon(Icons.edit),
          label: Text('Editar'),
          onPressed: () => Navigator.pop(context),
        ),
        RaisedButton.icon(
          color: Theme.of(context).buttonTheme.colorScheme.primary,
          textColor: Theme.of(context).buttonTheme.colorScheme.onPrimary,
          icon: Icon(
            pedido.isEnviando
                ? Icons.update
                : Icons.playlist_add_check,
          ),
          label: Text('Finalizar Pedido'),
          onPressed: () => _enviar(context),
        ),
      ],
    );
    
    if (Env.isDebuggin) {
      return Column(
        children: <Widget>[
          doneBar,
          editingBar,
        ],
      );
    } else if (pedido.isEnviando || pedido.isEnviado) {
      return doneBar;
    }
    return editingBar;
  }

  _enviar(BuildContext context) async {
    ScaffoldState scaffold = Scaffold.of(context);
    if (pedido.isEnviando || pedido.isEnviado) {
      scaffold
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Pedido já enviado'))
        );
      if (!Env.isDebuggin) {
        return;
      }
    }
    if (pedido.grupos.isEmpty) {
      scaffold
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text('Selecione ao menos uma configuração'))
        );
      if (!Env.isDebuggin) {
        return;
      }
    }
    for (GrupoImpressao grupo in pedido.grupos) {
      if (grupo.arquivos.isEmpty) {
        scaffold
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('Configuração sem arquivos é inválida'))
          );
        if (!Env.isDebuggin) {
          return;
        }
      }
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
