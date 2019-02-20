import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/support/form-radio.dart';
import 'package:tme_file_shr/support/pick-file.dart';

class PrintGroup extends StatelessWidget {
  final int id;
  PrintGroup({
    Key key,
    this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Pedido'),
      ),
      body: PrintGroupForm(id: id),
    );
  }
}

class PrintGroupForm extends StatefulWidget {
  final int id;
  PrintGroupForm({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _PrintGroupFormState createState() => _PrintGroupFormState(id: this.id);
}

class _PrintGroupFormState extends State<PrintGroupForm> {
  final _formKey = GlobalKey<FormState>();

  TamanhoDoc _tamanhoDoc;
  Duplex _duplex;
  Colorido _colorido;
  TamanhoFoto _tamanhoFoto;
  TipoPapelFoto _tipoPapelFoto;
  TipoGrupo _tipoGrupo;
  int _copias;
  int id;
  GrupoImpressao group;

  _PrintGroupFormState({
    Key key,
    this.id,
  });

  List<Widget> docConfigs() {
    return [
      ListTile(
        title: DropdownButtonFormField<TamanhoDoc>(
          decoration: InputDecoration(
            icon: Icon(Icons.straighten),
            labelText: 'Tamanho da folha',
            hintText: 'Escolha um tamaho de folha',
          ),
          value: _tamanhoDoc,
          onSaved: (TamanhoDoc newValue) => _tamanhoDoc = newValue,
          onChanged: (TamanhoDoc newValue) =>
              setState(() => _tamanhoDoc = newValue),
          items: tamanhoDocStr.entries
              .map((mapEntry) => DropdownMenuItem<TamanhoDoc>(
                    child: Text(mapEntry.value),
                    value: mapEntry.key,
                  ))
              .toList(),
        ),
      ),
      ListTile(
        title: FormRadio<Duplex>(
          decoration: InputDecoration(
            icon: const Icon(Icons.wrap_text),
            labelText: 'Lados de impressao',
            hintText: 'Escolha um tipo de papel',
          ),
          initialValue: _duplex,
          key1: const Text('Frente'),
          value1: Duplex.somenteFrente,
          key2: const Text('Frente e Verso'),
          value2: Duplex.duplex,
          onSaved: (Duplex newValue) => _duplex = newValue,
        ),
      ),
      ListTile(
        title: FormRadio<Colorido>(
          decoration: InputDecoration(
            icon: Icon(Icons.color_lens),
            labelText: 'Cores',
            hintText: 'Escolha as tintas',
          ),
          initialValue: _colorido,
          key1: const Text('Preto e Branco'),
          value1: Colorido.pretoBranco,
          key2: const Text('Colorido'),
          value2: Colorido.colorido,
          onSaved: (Colorido newValue) => _colorido = newValue,
        ),
      ),
    ];
  }

  List<Widget> fotoConfigs() {
    return [
      ListTile(
        title: DropdownButtonFormField<TamanhoFoto>(
          decoration: InputDecoration(
            icon: Icon(Icons.straighten),
            labelText: 'Tamanho da folha',
            hintText: 'Escolha um tamaho de folha',
          ),
          value: _tamanhoFoto,
          validator: (TamanhoFoto t) => t == null ? 'Tamanho deve ser especificado' : null,
          onSaved: (TamanhoFoto newValue) => _tamanhoFoto = newValue,
          onChanged: (TamanhoFoto newValue) =>
              setState(() => _tamanhoFoto = newValue),
          items: tamanhoFotoStr.entries
              .map((mapEntry) => DropdownMenuItem<TamanhoFoto>(
                    child: Text(mapEntry.value),
                    value: mapEntry.key,
                  ))
              .toList(),
        ),
      ),
      ListTile(
        title: FormRadio<TipoPapelFoto>(
          decoration: InputDecoration(
            icon: Icon(Icons.color_lens),
            labelText: 'Tipo de Papel',
            hintText: 'Escolha um tipo de papel',
          ),
          initialValue: _tipoPapelFoto,
          key1: Text('Brilhante\nTradicional'),
          value1: TipoPapelFoto.brilho,
          key2: Text('Fosco'),
          value2: TipoPapelFoto.fosco,
          onSaved: (TipoPapelFoto newValue) => _tipoPapelFoto = newValue,
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    List<GrupoImpressao> grupos = Pedido.of(context).grupos;
    this.group = grupos.firstWhere(
      (grupo) => grupo.id == this.id,
      orElse: () {
        GrupoImpressao group = GrupoImpressao();
        id = group.id;
        grupos.add(group);
        return group;
      }
    );
    this._tamanhoDoc = group.configDoc?.tamanhoDoc ?? TamanhoDoc.a4;
    this._duplex = group.configDoc?.duplex ?? Duplex.somenteFrente;
    this._colorido = group.configDoc?.colorido ?? Colorido.pretoBranco;
    this._tamanhoFoto = group.configFoto?.tamanhoFoto ?? TamanhoFoto.mm152x102;
    this._tipoPapelFoto = group.configFoto?.tipoPapelFoto ?? TipoPapelFoto.brilho;
    this._tipoGrupo = group.tipoGrupo ?? TipoGrupo.foto;
    this._copias = group.copias ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Hero(
        tag: 'print-group-card',
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButtonFormField<TipoGrupo>(
                decoration: const InputDecoration(
                  icon: Icon(Icons.assignment),
                  labelText: 'Tipo de impressão',
                ),
                value: _tipoGrupo,
                onSaved: (TipoGrupo newValue) => _tipoGrupo = newValue,
                onChanged: (TipoGrupo newValue) =>
                    setState(() => _tipoGrupo = newValue),
                items: tipoGrupoStr.entries
                    .map((mapEntry) => DropdownMenuItem<TipoGrupo>(
                          child: Text(mapEntry.value),
                          value: mapEntry.key,
                        ))
                    .toList(),
              ),
            ),
            ListTile(
              title: TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.filter_none),
                  labelText: 'Cópias',
                ),
                initialValue: _copias.toString(),
                keyboardType: TextInputType.number,
                onSaved: (String newValue) => _copias = int.tryParse(newValue),
                validator: (String value) {
                  int intVal = int.tryParse(value);
                  if (value.isEmpty || intVal == null || intVal <= 0) {
                    return 'Número de cópias é obrigatório';
                  }
                  return null;
                },
              ),
            ),
            // ------------**------------------------*-*-*------------------
            Divider(),
          ]
              .followedBy(
                _tipoGrupo == TipoGrupo.documento
                    ? docConfigs()
                    : fotoConfigs(),
              )
              .toList()
              .followedBy(
            [
              // ------------**------------------------*-*-*------------------
              Divider(),
              ListTile(
                title: RaisedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Salvar Configuração'),
                  onPressed: _salvarConfig,
                ),
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }

  _salvarConfig() async {
    FormState formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      if (this.group == null) {
        this.group = Pedido.of(context).grupos.firstWhere((grupo) => grupo.id == this.id);
      }
      this.group.setConfig(
        tamanhoDoc: _tamanhoDoc,
        duplex: _duplex,
        colorido: _colorido,
        tamanhoFoto: _tamanhoFoto,
        tipoPapelFoto: _tipoPapelFoto,
        tipoGrupo: _tipoGrupo,
        copias: _copias,
      );
      this.group = await Navigator.push<GrupoImpressao>(
        context,
        MaterialPageRoute(builder: (context) => PickFile(grupo: this.group,)),
      );
      if (this.group == null || this.group.arquivos.isEmpty) {
        print('[AddGroup] Selecione ao menos um arquivo');
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text('Selecione ao menos um arquivo'))
          );
        return;
      }
      Navigator.pop<GrupoImpressao>(context, this.group);
    }
  }
}
