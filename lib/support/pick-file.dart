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
  @override
  Widget build(BuildContext context) {
    bool isDoc = widget.grupo.tipoGrupo == TipoGrupo.documento;
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
        padding: const EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 2,
        children: (widget.grupo.arquivos.map<Widget>((Arquivo arq) => GridTile(
                  header: GestureDetector(
                    // onTap: () { onBannerTap(photo); },
                    child: GridTileBar(
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(arq.filename),
                      ),
                      backgroundColor: Colors.black45,
                      leading: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  child: isDoc ? Text('') : Image.file(File(arq.path)),
                )))
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
