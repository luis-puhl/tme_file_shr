import 'package:flutter/material.dart';

import 'package:tme_file_shr/models.dart';

class PrintGroupCard extends StatelessWidget {
  final GrupoImpressao grupo;
  
  PrintGroupCard({
    this.grupo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
          ),
        ],
      ),
    );
  }
}
