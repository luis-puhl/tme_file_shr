import { API_KEYS } from './../environments/api-keys';

export enum Loja {
  loja1 = 'loja1',
  loja2 = 'loja2',
  loja3 = 'loja3',
  loja4 = 'loja4',
}
export class LojaInfo {
  public key: Loja;
  public nome: string;
  public endereco: string;
  public email: string;
  public whatsapp: string;
  public telefone: Array<String>;
  public chatId: number;

  constructor(
    bag: {
      key: Loja,
      nome: string,
      endereco: string,
      email: string,
      whatsapp: string,
      telefone: Array<String>,
      chatId: number,
    }
  ) {
    this.key = bag.key;
    this.nome = bag.nome;
    this.endereco = bag.endereco;
    this.email = bag.email;
    this.whatsapp = bag.whatsapp;
    this.telefone = bag.telefone;
    this.chatId = bag.chatId;
  }

  public get enderecoWebURI(): string {
    return 'https://www.google.com/maps?q=' + this.endereco.replace(' ', '+');
  }
  public get enderecoAndroidURI(): string {
    return 'geo:0,0?q=' + this.endereco.replace(' ', '%20');
  }
  public get enderecoWhatsappURI(): string {
    return 'https://wa.me/55' + this.whatsapp.replace(RegExp('[ \+\.\-]'), '');
  }
  public get enderecoEmailURI(): string {
    return `mailto:${this.email}?subject=App%20FotoCelula%20Express`;
  }
}

export const lojaStr = {
  // Filial 2
  [Loja.loja1]: new LojaInfo({
    key: Loja.loja1,
    nome: 'Quintino',
    chatId: API_KEYS.LOJA_QUINTINO_ID,
    endereco: 'Rua Quintino Bocaiúva, 555 - Londrina',
    telefone: ['(43) 3323-5483', '(43) 3323-5533'],
    whatsapp: '(43) 9.9838-2121',
    email: 'loja.quintino@fotocelula.com.br',
  }),
  // Filial 4
  [Loja.loja2]: new LojaInfo({
    key: Loja.loja2,
    nome: 'Comtur',
    chatId: API_KEYS.LOJA_COMTUR_ID,
    endereco: 'Av. Tiradentes, 1241 Sl 03 - Bl. A Shop. ComTur - Londrina',
    telefone: ['(43) 3344-5130', '(43) 3327-3746'],
    whatsapp: '(43) 9.9991-3268',
    email: 'loja.comtur@fotocelula.com.br',
  }),
  // Filial 8
  [Loja.loja3]: new LojaInfo({
    key: Loja.loja3,
    nome: 'Higienopolis',
    chatId: API_KEYS.LOJA_HIGI_ID,
    endereco: 'Av. Higienópolis, 1056 - Londrina',
    telefone: ['(43) 3339-3442', '(43) 3344-0213'],
    whatsapp: '(43) 9.9838-1414',
    email: 'loja.higienopolis@fotocelula.com.br',
  }),
  // Nossa Matriz
  [Loja.loja4]: new LojaInfo({
    key: Loja.loja4,
    nome: 'Centro',
    chatId: API_KEYS.LOJA_CENTRO_ID,
    endereco: 'Av. Rio de Janeiro, 158 - Londrina',
    telefone: ['(43) 3323-2640'],
    whatsapp: '(43) 9.9838-2120',
    email: 'loja.centro@fotocelula.com.br',
  }),
};
