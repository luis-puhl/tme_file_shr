import { API_KEYS } from './../environments/api-keys';

export enum Store {
  store1 = 'store1',
  store2 = 'store2',
  store3 = 'store3',
  store4 = 'store4',
}
export class StoreInfo {
  public key: Store;
  public name: string;
  public address: string;
  public email: string;
  public whatsapp: string;
  public phone: Array<String>;
  public chatId: number;

  constructor(
    bag: {
      key: Store,
      name: string,
      address: string,
      email: string,
      whatsapp: string,
      phone: Array<String>,
      chatId: number,
    }
  ) {
    this.key = bag.key;
    this.name = bag.name;
    this.address = bag.address;
    this.email = bag.email;
    this.whatsapp = bag.whatsapp;
    this.phone = bag.phone;
    this.chatId = bag.chatId;
  }

  public get addressWebURI(): string {
    return 'https://www.google.com/maps?q=' + this.address.replace(' ', '+');
  }
  public get addressAndroidURI(): string {
    return 'geo:0,0?q=' + this.address.replace(' ', '%20');
  }
  public get whatsappURI(): string {
    return 'https://wa.me/55' + this.whatsapp.replace(/ |\+|\.|\-|\(|\)/gi, '');
  }
  public get emailURI(): string {
    return `mailto:${this.email}?subject=App%20FotoCelula%20Express`;
  }
}

export const storeStr = {
  // Filial 2
  [Store.store1]: new StoreInfo({
    key: Store.store1,
    name: 'Quintino',
    chatId: API_KEYS.LOJA_QUINTINO_ID,
    address: 'Rua Quintino Bocaiúva, 555 - Londrina',
    phone: ['(43) 3323-5483', '(43) 3323-5533'],
    whatsapp: '(43) 9.9838-2121',
    email: 'store.quintino@fotocelula.com.br',
  }),
  // Filial 4
  [Store.store2]: new StoreInfo({
    key: Store.store2,
    name: 'Comtur',
    chatId: API_KEYS.LOJA_COMTUR_ID,
    address: 'Av. Tiradentes, 1241 Sl 03 - Bl. A Shop. ComTur - Londrina',
    phone: ['(43) 3344-5130', '(43) 3327-3746'],
    whatsapp: '(43) 9.9991-3268',
    email: 'store.comtur@fotocelula.com.br',
  }),
  // Filial 8
  [Store.store3]: new StoreInfo({
    key: Store.store3,
    name: 'Higienopolis',
    chatId: API_KEYS.LOJA_HIGI_ID,
    address: 'Av. Higienópolis, 1056 - Londrina',
    phone: ['(43) 3339-3442', '(43) 3344-0213'],
    whatsapp: '(43) 9.9838-1414',
    email: 'store.higienopolis@fotocelula.com.br',
  }),
  // Nossa Matriz
  [Store.store4]: new StoreInfo({
    key: Store.store4,
    name: 'Centro',
    chatId: API_KEYS.LOJA_CENTRO_ID,
    address: 'Av. Rio de Janeiro, 158 - Londrina',
    phone: ['(43) 3323-2640'],
    whatsapp: '(43) 9.9838-2120',
    email: 'store.centro@fotocelula.com.br',
  }),
};
