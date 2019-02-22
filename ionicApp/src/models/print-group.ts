import { PrintFile } from './print-file';
import './arquivo.dart';
import { id } from './id';


export enum TipoGrupo {
  foto = 'Fotos',
  documento = 'Documentos',
}
export enum TamanhoDoc {
  a3 = 'A3',
  a4 = 'A4',
  a5 = 'A5',
  a6 = 'A6',
}
export enum TamanhoFoto {
  mm152x102 = '15,2 x 10,2 cm (padrão 4x6in 3:2)',
  mm152x210 = '15,2 x 21,0 cm',
  mm129x89 = '12,9 x 8,9 cm',
  mm129x180 = '12,9 x 18,0 cm',
  mm203x254 = '20,3 x 25,4 cm',
  mm203x305 = '20,3 x 30,5 cm',
  mm254x305 = '25,4 x 30,5 cm',
  mm254x380 = '25,4 x 38 cm',
  mm305x406 = '30,5 x 40,6 cm',
  mm305x450 = '30,5 x 45 cm',
  mm400x600 = '40 x 60 cm',
  mm500x600 = '50 x 60 cm',
  mm500x700 = '50 x 70 cm',
  mm500x750 = '50 x 75 cm',
  mm600x900 = '60 x 90 cm',
}
export enum Duplex {
  somenteFrente = 'Frente',
  duplex = 'Duplex',
}
export enum Colorido {
  colorido = 'Colorido',
  pretoBranco = 'Preto e Branco',
}

abstract class BaseConfig {
  abstract toMessage(): string;
}

export class ConfigDoc extends BaseConfig {
  tamanhoDoc: TamanhoDoc = TamanhoDoc.a4;
  duplex: Duplex         = Duplex.somenteFrente;
  colorido: Colorido     = Colorido.pretoBranco;

  toString() {
    return `tamanho: ${this.tamanhoDoc}, duplex: ${this.duplex}, colorido: ${this.colorido}`;
  }

  toMessage() {
    return `\nTamanho: ${this.tamanhoDoc}\nDuplex: ${this.duplex}\nColorido: ${this.colorido}`;
  }
}

export enum TipoPapelFoto {
  brilho = 'Brilhante Tradicional',
  fosco = 'Fosco Premium',
}

export class ConfigFoto extends BaseConfig {
  tamanhoFoto: TamanhoFoto = TamanhoFoto.mm152x102;
  tipoPapelFoto: TipoPapelFoto = TipoPapelFoto.brilho;

  toString() {
    return `tamanhoFoto: ${this.tamanhoFoto}, tipoPapelFoto: ${this.tipoPapelFoto}`;
  }
  toMessage() {
    return `\nTamanho: ${this.tamanhoFoto}\nTipo Papel: ${this.tipoPapelFoto}`;
  }
}


export class PrintGroup {
  id = id();
  tipoGrupo: TipoGrupo = TipoGrupo.foto;
  copias = 1;
  configDoc: ConfigDoc = new ConfigDoc();
  configFoto: ConfigFoto = new ConfigFoto();
  arquivos: PrintFile[] = [];

  async getSize() {
    let size = 0;
    for (const arq of this.arquivos) {
      size += (await arq.getSize()) || 0;
    }
    return size;
  }
  get config() {
    switch (this.tipoGrupo) {
      case TipoGrupo.documento:
        return this.configDoc;
      case TipoGrupo.foto:
        return this.configFoto;
    }
    return this.configDoc;
  }

  toString() {
    return `id: ${this.id}, tipoGrupo: ${this.tipoGrupo}, copias: ${this.copias}, arquivos: ${this.arquivos.length} config: ${this.config}`;
  }
  toSubTitleString() {
    if (this.tipoGrupo === TipoGrupo.documento) {
      return `$copias cópias\n` +
        `${this.configDoc.colorido}\n` +
        `${this.configDoc.tamanhoDoc} ${this.configDoc.duplex}`;
    }
    return `$copias cópias\n` +
      `${this.configFoto} ${this.configFoto}`;
  }

  setConfig(bag: {
    tamanhoDoc: TamanhoDoc,
    duplex: Duplex,
    colorido: Colorido,
    tamanhoFoto: TamanhoFoto,
    tipoPapelFoto: TipoPapelFoto,
    tipoGrupo: TipoGrupo,
    copias: number,
  }) {
    this.copias = Math.max(1, bag.copias);
    this.tipoGrupo = bag.tipoGrupo;
    switch (this.tipoGrupo) {
      case TipoGrupo.documento:
        this.configDoc.colorido = bag.colorido;
        this.configDoc.duplex = bag.duplex;
        this.configDoc.tamanhoDoc = bag.tamanhoDoc;
        break;
      case TipoGrupo.foto:
        this.configFoto.tamanhoFoto = bag.tamanhoFoto;
        this.configFoto.tipoPapelFoto = bag.tipoPapelFoto;
    }
    // this.notifyListeners();
  }

  toMessage() {
    return `Cópias: $copias` +
      `\nPrintFiles: ${this.arquivos.length}` +
      `\nConfiguração: ${this.config.toMessage()}`;
  }
}
