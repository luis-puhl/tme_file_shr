import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:teledart/teledart.dart';

import 'package:tme_file_shr/support/telegram-patch.dart';

int getId() {
  Random r = Random.secure();
  return r.nextInt(1<<32);
}

enum PedidoStatus { vazio, identificado, preenchido, enviado }

class Pedido extends Model {
  PedidoStatus status = PedidoStatus.vazio;
  String nome, telefone;
  Loja lojaRetirada;
  DateTime dataRetirada;
  List<GrupoImpressao> grupos = [];
  String statusString = '';

  static Pedido of(BuildContext context) => ScopedModel.of<Pedido>(context);

  String toSubTitle() {
    return (telefone != null ? telefone : 'null') + '\n' +
      (lojaRetirada != null ? lojaStr[lojaRetirada] : '') + '\n' +
      (dataRetirada != null ? DateFormat('dd\/MM\/yyyy', 'ptBR').format(dataRetirada) : '');
  }

  String toString() {
    return 'nome: ' + (nome != null ? nome : 'null') + ', ' +
      'telefone: ' + (telefone != null ? telefone : 'null') + ', ' +
      'loja Retirada: ' + (lojaRetirada != null ? lojaStr[lojaRetirada] : '') + ', ' +
      'data Retirada: ' + (dataRetirada != null ? DateFormat('dd\/MM\/yyyy', 'ptBR').format(dataRetirada) : '');
  }

  setIdentification(String nome, String telefone, Loja lojaRetirada, DateTime dataRetirada) {
    this.nome = nome;
    this.telefone = telefone;
    this.lojaRetirada = lojaRetirada;
    this.dataRetirada = dataRetirada;
    this.status = PedidoStatus.identificado;
    this.notifyListeners();
  }

  bool isEnviando = false;
  bool isEnviado = false;
  enviar() async {
    try {
      await this.enviarActual();
    } catch (e) {
      print(e);
      status = PedidoStatus.preenchido;
      isEnviado = false;
      statusString = 'Falha ao enviar';
    } finally {
      isEnviando = false;
      this.notifyListeners();
    }
  }
  enviarActual() async {
    isEnviando = true;
    this.notifyListeners();

    String ordem = '${nome.replaceAll(' ', '-')}_${telefone}_${DateFormat('yyyy-MM-dd_HH-mm', 'ptBR').format(dataRetirada)}';
    String message = '# Informações gerais\n'
      '\nCliente: $nome'
      '\nTelefone: $telefone'
      '\nData da emissão: ${DateFormat('dd\/MM\/yyyy', 'ptBR').format(DateTime.now())}'
      '\nData de entrega: ${DateFormat('dd\/MM\/yyyy', 'ptBR').format(dataRetirada)}'
      '\n'
      ;
    String caption = message.toString();

    Archive archive = Archive();

    statusString = 'Verificando arquivos';
    this.notifyListeners();
    for (var grupo in grupos) {
      for (var arquivo in grupo.arquivos) {
        int duplicados = grupo.arquivos.where((arq) => arq.filename == arquivo.filename).length;
        if (duplicados > 1 || arquivo.filename == ordem + '.txt'){
          arquivo.filename = duplicados.toString() + '_' + arquivo.filename;
        }
      }
    }
    for (var grupo in grupos) {
      message += '\n# Lote ${grupos.indexOf(grupo) + 1} ${tipoGrupoStr[grupo.tipoGrupo]}\n' + grupo.toMessage();
      for (var arquivo in grupo.arquivos) {
        message += '\nNome arquivo: ${arquivo.filename}';
        List<int> content = await File(arquivo.path).readAsBytes();
        archive.addFile(
          ArchiveFile(arquivo.filename, content.length, content)
        );
      }
      message += '\n';
    }
    statusString = 'Comprimindo arquivos';
    this.notifyListeners();
    List<int> content = Utf8Codec().encode(message.replaceAll('\n', '\r\n'));
    archive.addFile(
      ArchiveFile(ordem + '.txt', content.length, content)
    );

    File tempZipFile = File((await Directory.systemTemp.createTemp()).path + '/teste.zip');
    await tempZipFile.writeAsBytes(
      ZipEncoder().encode(archive)
    );

    statusString = 'Enviando arquivos para telegram';
    this.notifyListeners();
    String telegramToken = String.fromEnvironment('telegramToken', defaultValue: null);
    int telegramGroupId = int.fromEnvironment('telegramGroupId', defaultValue: null);
    
    if (telegramToken == null || telegramGroupId == null) {
      String rawDotEnv = await rootBundle.loadString('.env');
      Map<String, String> dotEnv = {};
      for (var line in rawDotEnv.trim().replaceAll('\r', '').split('\n')) {
        List<String> kv = line.split('=');
        dotEnv[kv[0]] = kv[1];
      }
      telegramToken = dotEnv['telegramToken'];
      telegramGroupId = int.tryParse(dotEnv['telegramGroupId']);
    }

    assert(telegramToken != null, 'Sem telegram token');
    assert(telegramGroupId != null, 'Sem telegram group id');
    if (telegramToken == null) throw 'Sem telegram token';
    if (telegramGroupId == null) throw 'Sem telegram group id';

    TelegramPatch telegram = TelegramPatch(telegramToken);
    TeleDart(telegram, Event());
    await telegram.sendDocument(telegramGroupId, tempZipFile, caption: caption, fileName: ordem + '.zip');
    status = PedidoStatus.enviado;
    isEnviado = true;
    statusString = 'Ordem enviada';
    isEnviando = false;
    this.notifyListeners();
  }
}

class GrupoImpressao extends Model {
  final int id = getId();
  TipoGrupo _tipoGrupo = TipoGrupo.documento;
  int copias = 1;
  ConfigDoc configDoc = ConfigDoc();
  ConfigFoto configFoto;

  List<Arquivo> arquivos = [];

  TipoGrupo get tipoGrupo => _tipoGrupo;
  set tipoGrupo(TipoGrupo tp) {
    if (tp != _tipoGrupo) {
      switch (tp) {
        case TipoGrupo.documento:
          configDoc = ConfigDoc();
          configFoto = null;
          break;
        case TipoGrupo.foto:
          configDoc = null;
          configFoto = ConfigFoto();
          break;
        default:
      }
    }
    _tipoGrupo = tp;
  }
  BaseConfig get config {
    switch (_tipoGrupo) {
      case TipoGrupo.documento:
        return configDoc;
      case TipoGrupo.foto:
        return configFoto;
    }
    return configDoc;
  }

  @override
  String toString() {
    return "id: $id, tipoGrupo: $tipoGrupo, copias: $copias, arquivos: ${arquivos.length} config: $config";
  }
  
  String toSubTitleString() {
    if (_tipoGrupo == TipoGrupo.documento) {
      return "$copias cópias\n"
        "${coloridoStr[configDoc.colorido]}\n"
        "${tamanhoDocStr[configDoc.tamanhoDoc]} ${duplexStr[configDoc.duplex]}";
    }
    return "$copias cópias\n"
      "${tamanhoFotoStr[configFoto.tamanhoFoto]} ${tipoPapelFotoStr[configFoto.tipoPapelFoto]}";
  }

  void setConfig({
    TamanhoDoc tamanhoDoc,
    Duplex duplex,
    Colorido colorido,
    TamanhoFoto tamanhoFoto,
    TipoPapelFoto tipoPapelFoto,
    TipoGrupo tipoGrupo,
    int copias,
  }) {
    this.copias = max<int>(1, copias);
    this.tipoGrupo = tipoGrupo;
    switch (_tipoGrupo) {
      case TipoGrupo.documento:
        configDoc
          ..colorido = colorido
          ..duplex = duplex
          ..tamanhoDoc = tamanhoDoc;
        break;
      case TipoGrupo.foto:
        configFoto
          ..tamanhoFoto = tamanhoFoto
          ..tipoPapelFoto = tipoPapelFoto;
    }
    this.notifyListeners();
  }

  String toMessage() {
    return 'Cópias: $copias'
      '\nArquivos: ${arquivos.length}'
      '\nConfiguração: ${config.toMessage()}'
      ;
  }
}

class Arquivo extends Model {
  String path, filename;

  Arquivo({
    this.path,
  }) {
    filename = path.split('/').last;
  }
}

enum Loja { loja1, loja2, loja3, loja4, }
Map<Loja, String> lojaStr = {
  Loja.loja1: 'Loja 1',
  Loja.loja2: 'Loja 2',
  Loja.loja3: 'Loja 3',
  Loja.loja4: 'Loja 4',
};

enum TipoGrupo { documento, foto, }
Map<TipoGrupo, String> tipoGrupoStr = {
  TipoGrupo.documento: 'Documentos',
  TipoGrupo.foto: 'Fotos',
};
enum TamanhoDoc { a3, a4, a5, a6, }
Map<TamanhoDoc, String> tamanhoDocStr = {
  TamanhoDoc.a3: 'A3',
  TamanhoDoc.a4: 'A4',
  TamanhoDoc.a5: 'A5',
  TamanhoDoc.a6: 'A6',
};
enum TamanhoFoto {
  mm152x102,
  mm152x210,
  mm129x89,
  mm129x180,
  mm203x254,
  mm203x305,
  mm254x305,
  mm254x380,
  mm305x406,
  mm305x450,
  mm400x600,
  mm500x600,
  mm500x700,
  mm500x750,
  mm600x900,
}
Map<TamanhoFoto, String> tamanhoFotoStr = {
  TamanhoFoto.mm152x102: '15,2 x 10,2 cm',
  TamanhoFoto.mm152x210: '15,2 x 21,0 cm',
  TamanhoFoto.mm129x89: '12,9 x 8,9 cm',
  TamanhoFoto.mm129x180: '12,9 x 18,0 cm',
  TamanhoFoto.mm203x254: '20,3 x 25,4 cm',
  TamanhoFoto.mm203x305: '20,3 x 30,5 cm',
  TamanhoFoto.mm254x305: '25,4 x 30,5 cm',
  TamanhoFoto.mm254x380: '25,4 x 38 cm',
  TamanhoFoto.mm305x406: '30,5 x 40,6 cm',
  TamanhoFoto.mm305x450: '30,5 x 45 cm',
  TamanhoFoto.mm400x600: '40 x 60 cm',
  TamanhoFoto.mm500x600: '50 x 60 cm',
  TamanhoFoto.mm500x700: '50 x 70 cm',
  TamanhoFoto.mm500x750: '50 x 75 cm',
  TamanhoFoto.mm600x900: '60 x 90 cm',
};

enum Duplex { duplex, somenteFrente, }
Map<Duplex, String> duplexStr = {
  Duplex.somenteFrente: 'Frente',
  Duplex.duplex: 'Duplex',
};
enum Colorido { colorido, pretoBranco, }
Map<Colorido, String> coloridoStr = {
  Colorido.colorido: 'Colorido',
  Colorido.pretoBranco: 'Preto e Branco',
};

abstract class BaseConfig {
  String toMessage();
}

class ConfigDoc extends BaseConfig {
  TamanhoDoc tamanhoDoc = TamanhoDoc.a4;
  // frente, frente_verso,
  Duplex duplex = Duplex.somenteFrente;
  // colorido ou PB
  Colorido colorido = Colorido.pretoBranco;

  @override
  String toString() {
    return "tamanho: $tamanhoDoc, duplex: $duplex, colorido: $colorido";
  }

  @override
  String toMessage() {
    return '\nTamanho: ${tamanhoDocStr[tamanhoDoc]}\nDuplex: ${duplexStr[duplex]}\nColorido: ${coloridoStr[colorido]}';
  }
}

enum TipoPapelFoto { brilho, fosco, }
Map<TipoPapelFoto, String> tipoPapelFotoStr = {
  TipoPapelFoto.brilho: 'Brilhante Tradicional',
  TipoPapelFoto.fosco: 'Fosco Premium',
};

class ConfigFoto extends BaseConfig{
  TamanhoFoto tamanhoFoto = TamanhoFoto.mm203x305;
  TipoPapelFoto tipoPapelFoto = TipoPapelFoto.brilho;

  @override
  String toString() {
    return "tamanhoFoto: $tamanhoFoto, tipoPapelFoto: $tipoPapelFoto";
  }
  @override
  String toMessage() {
    return '\nTamanho: ${tamanhoFotoStr[tamanhoFoto]}\nTipo Papel: ${tipoPapelFotoStr[tipoPapelFoto]}';
  }
}
