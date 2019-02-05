import 'package:flutter/material.dart';
import 'package:tme_file_shr/support/file.dart';

class AddFile extends StatefulWidget {
  @override
  _AddFileState createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  List<FileSelected> files = [];

  Widget _buildCards() {
    return files.map(file => FileCard(file)).toList()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Pedido'),
      ),
      body: Container(
        color: Colors.purple,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: <Widget>[
            FileCard(),
            FileCard(),
            RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Salvar",
                style: TextStyle(fontSize: 25.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FileCard extends StatefulWidget {
  @override
  _FileCardState createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  FileSelected file;

  void _openFileExplorer() async {
    FileSelected file = await SupportFile.openFileExplorer();
    setState(() {
      this.file = file;
    });
  }

  @override
  Widget build(BuildContext context) {
   return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: this.file != null ? Text(this.file.fileName) : Text('Arquivo'),
              subtitle: Text('Tamanho 15x33\nCópias 1\nCaminho ' + (this.file != null ? this.file.path : '')),
            ),
            ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(Icons.edit),
                    label: const Text('Editar'),
                    onPressed: () => _openFileExplorer(),
                  ),
                  FlatButton.icon(
                    icon: Icon(Icons.attach_file),
                    label: const Text('Arquivo'),
                    onPressed: () => _openFileExplorer(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
