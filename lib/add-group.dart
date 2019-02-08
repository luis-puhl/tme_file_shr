import 'package:flutter/material.dart';

import 'package:tme_file_shr/models.dart';
import 'package:tme_file_shr/main.dart';
import 'package:scoped_model/scoped_model.dart';

class PrintGroup extends StatefulWidget {
  final int id;
  PrintGroup({
    Key key,
    this.id,
  }): super(key: key);

  @override
  _PrintGroupState createState() => _PrintGroupState(id: this.id);
}

class _PrintGroupState extends State<PrintGroup> {
  final _formKey = GlobalKey<FormState>();

  TamanhoDoc _tamanhoDoc;
  Duplex _duplex;
  Colorido _colorido;
  TamanhoFoto _tamanhoFoto;
  TipoPapelFoto _tipoPapelFoto;
  TipoGrupo _tipoGrupo;
  int _copias;
  int id;
  _PrintGroupState({
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
          onChanged: (TamanhoDoc newValue) => setState(() => _tamanhoDoc = newValue),
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
          initialValue: Duplex.somenteFrente,
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
          initialValue: Colorido.pretoBranco,
          // icon: const Icon(Icons.color_lens),
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
          onSaved: (TamanhoFoto newValue) => _tamanhoFoto = newValue,
          onChanged: (TamanhoFoto newValue) => setState(() => _tamanhoFoto = newValue),
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
          initialValue: TipoPapelFoto.brilho,
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
    var grupos = Pedido.of(context).grupos;
    GrupoImpressao group = grupos.firstWhere(
      (grupo) => grupo.id == this.id,
      orElse: () {
        var group = GrupoImpressao();
        id = group.id;
        grupos.add(group);
        return group;
      }
    );
    _tamanhoDoc = group.configDoc?.tamanhoDoc;
    _duplex = group.configDoc?.duplex;
    _colorido = group.configDoc?.colorido;
    _tamanhoFoto = group.configFoto?.tamanhoFoto;
    _tipoPapelFoto = group.configFoto?.tipoPapelFoto;
    _tipoGrupo = group.tipoGrupo;
    _copias = group.copias;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.title),
      ),
      body: Form(
        key: _formKey,
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
                onChanged: (TipoGrupo newValue) => setState(() => _tipoGrupo = newValue),
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
          ].followedBy(
            _tipoGrupo == TipoGrupo.documento ? docConfigs() : fotoConfigs(),
          ).toList().followedBy(
            [
              // ------------**------------------------*-*-*------------------
              Divider(),
              ListTile(
                title: RaisedButton.icon(
                  icon: Icon(Icons.attach_file),
                  label: Text('Salvar Configuração'),
                  onPressed: () {
                    FormState formState = _formKey.currentState;
                    if (formState.validate()) {
                      formState.save();
                      GrupoImpressao group = Pedido.of(context)?.grupos?.firstWhere((grupo) => grupo.id == this.id);
                      group.setConfig(
                        tamanhoDoc: _tamanhoDoc,
                        duplex: _duplex,
                        colorido: _colorido,
                        tamanhoFoto: _tamanhoFoto,
                        tipoPapelFoto: _tipoPapelFoto,
                        tipoGrupo: _tipoGrupo,
                        copias: _copias,
                      );
                      Navigator.pop(context, group);
                    }
                  }
                ),
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}

class FormRadio<T> extends FormField<T> {
  final T initialValue, value1, value2;
  final Icon icon;
  final Widget key1, key2;
  final InputDecoration decoration;
  FormRadio({
    Key key,
    this.initialValue,
    this.value1,
    this.value2,
    this.icon,
    this.key1,
    this.key2,
    T value,
    this.onChanged,
    @required this.decoration,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    Widget hint,
  }): super(
    key: key,
    onSaved: onSaved,
    initialValue: initialValue,
    validator: validator,
    builder: (FormFieldState<T> field) {
      final InputDecoration effectiveDecoration = decoration.applyDefaults(Theme.of(field.context).inputDecorationTheme);
      return InputDecorator(
        decoration: effectiveDecoration.copyWith(errorText: field.errorText, ),
        isEmpty: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<T>(
                  value: value1,
                  groupValue: field.value,
                  onChanged: field.didChange,
                ),
                key1,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<T>(
                  value: value2,
                  groupValue: field.value,
                  onChanged: field.didChange,
                ),
                key2,
              ],
            ),
          ],
        ),
      );
    } // builder
  );

  /// Called when the user selects an item.
  final ValueChanged<T> onChanged;

  @override
  FormFieldState<T> createState() => _FormRadioState<T>();
}

class _FormRadioState<T> extends FormFieldState<T> {
  @override
  FormRadio<T> get widget => super.widget;

  @override
  void didChange(T value) {
    super.didChange(value);
    if (widget.onChanged != null)
      widget.onChanged(value);
  }
}