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

  @override
  Widget build(BuildContext context) {
    isDoc = widget.grupo.tipoGrupo == TipoGrupo.documento;
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar ' + (isDoc ? ' documentos' : ' fotos')),
      ),
      floatingActionButton: _FabPicker(widget.grupo),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        crossAxisCount: 2,
        children: _buildGrid(),
      ),
    );
  }

  List<Widget> _buildGrid() {
    List<Widget> grid = [];
    grid.addAll(widget.grupo.arquivos
        .map<Widget>((Arquivo arq) => _buildGridTile(context, arq)));
    grid.add(
      RaisedButton.icon(
        icon: Icon(Icons.attach_file),
        label: Text('Adicionar\n' + (isDoc ? ' documentos' : ' fotos')),
        onPressed: _addFile,
      ),
    );
    return grid;
  }

  _addFile() async {
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
      print("PlatformException while picking the file: " + e.toString());
    } catch (e) {
      print("Error while picking the file: " + e.toString());
    }
  }

  _buildGridTile(BuildContext context, Arquivo arq) {
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
          onPressed: () => setState(() => widget.grupo.arquivos.removeWhere((arqivo) => arqivo.path == arq.path)),
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
}

class _FabPicker extends StatefulWidget {
  final GrupoImpressao grupo;
  _FabPicker(this.grupo);
  @override
  _FabPickerState createState() {
    return new _FabPickerState();
  }
}

class _FabPickerState extends State<_FabPicker> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          if (widget.grupo.arquivos.isEmpty) {
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('Selecione ao menos um arquivo'))
              );
            return;
          }
          Navigator.pop(context, widget.grupo);
        },
        tooltip: 'Comfirmar Seleção',
        child: Icon(Icons.check),
      );
  }
}