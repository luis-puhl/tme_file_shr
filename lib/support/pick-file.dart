import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

import 'package:tme_file_shr/models.dart';

class PickFile extends StatefulWidget {
  final GrupoImpressao grupo;

  PickFile({
    this.grupo,
  });

  @override
  _PickFileState createState() => _PickFileState();
}

class _PickFileState extends State<PickFile> {
  bool isDoc;

  buildGridTile(BuildContext context, Arquivo arq) {
    return GridTile(
      footer: GridTileBar(
        title: Text(
          arq.filename,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.white,
          onPressed: () => setState(() {
                widget.grupo.arquivos
                    .removeWhere((arqivo) => arqivo.path == arq.path);
              }),
        ),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.12),
        child: isDoc
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      arq.filename,
                      softWrap: true,
                    ),
                    Icon(
                      Icons.insert_drive_file,
                      size: 50,
                    )
                  ],
                ),
              )
            : Image.file(File(arq.path)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    isDoc = widget.grupo.tipoGrupo == TipoGrupo.documento;
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar ' + (isDoc ? ' documentos' : ' fotos')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, widget.grupo);
        },
        tooltip: 'Increment',
        child: Icon(Icons.check),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        crossAxisCount: 2,
        children: (widget.grupo.arquivos
                .map<Widget>((Arquivo arq) => buildGridTile(context, arq)))
            .followedBy([
          RaisedButton.icon(
            icon: Icon(Icons.attach_file),
            label: Text('Adicionar\n' + (isDoc ? ' documentos' : ' fotos')),
            onPressed: () async {
              try {
                String filePath = '';
                filePath = await FilePicker.getFilePath(type: FileType.ANY);
                if (filePath == '') {
                  return;
                }
                print("File path: " + filePath);
                setState(() {
                  widget.grupo.arquivos.add(Arquivo(path: filePath));
                });
              } on PlatformException catch (e) {
                print("PlatformException while picking the file: " +
                    e.toString());
              } catch (e) {
                print("Error while picking the file: " + e.toString());
              }
            },
          ),
        ]).toList(),
      ),
    );
  }
}
