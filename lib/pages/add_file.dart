import 'package:flutter/material.dart';
import 'package:tme_file_shr/main.dart';

class AddFile extends StatelessWidget {
  void _openFileExplorer() async {
    // _path = SupportFile.openFileExplorer();
    // setState(() {
    //   _fileName = _path != null ? _path.split('/').last : '...';
    // });
  }

  Widget _buildCard() {
    return Container(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              leading: Icon(Icons.insert_drive_file),
              title: Text('Pôster Loja'),
              subtitle: Text('Tamanho 15x33\nCópias 1'),
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
            _buildCard(),
            _buildCard(),
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

class CopiasButton extends StatefulWidget {
  @override
  _CopiasButtonState createState() => _CopiasButtonState();
}

class _CopiasButtonState extends State<CopiasButton> {
  bool editing = false;
  int ammount = 1;

  Widget _buildTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: "Cópias",
        hintStyle: TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        prefixIcon: Icon(
          Icons.face,
          color: Colors.white,
        ),
      ),
      onSubmitted: (String str) {
        print(str);
      },
      autofocus: true,
    );
  }

  Widget _buildLabel() {
    if (ammount == 1) {
      return Text('1 cópia');
    }
    return Text(ammount.toString() + ' cópias');
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: editing ? _buildTextField() : _buildLabel(),
      onPressed: () => setState(() => editing = true),
    );
  }
}
