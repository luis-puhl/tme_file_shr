import 'dart:math';
import 'package:scoped_model/scoped_model.dart';

int getId() {
  Random r = Random.secure();
  return r.nextInt(1<<32);
}

class GrupoImpressao extends Model {
  final int id = getId();
  TipoGrupo _tipoGrupo = TipoGrupo.documento;
  int copias = 1;
  ConfigDoc configDoc = ConfigDoc();
  ConfigFoto configFoto;

  List<Arquivo> arquivos = [];

  TipoGrupo get tipoGrupo => _tipoGrupo;

  get size => arquivos.fold<int>(0, (acc, arq) => acc + arq.size);
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
  int size;

  Arquivo(
    this.path,
    this.size,
  ) {
    filename = path.split('/').last;
  }
}

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
