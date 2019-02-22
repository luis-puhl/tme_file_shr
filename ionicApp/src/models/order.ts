import { Store, storeStr } from './store';
import { id } from './id';
import { PrintGroup } from './print-group';

export enum OrderStatus { empty, id, filled, sent }

export enum WeekDay {
  Sunday = 0,
  Monday = 1,
  Tuesday = 2,
  Wednesday = 3,
  Thursday = 4,
  Friday = 5,
  Saturday = 6
}

export function duration(b?: {
  years?: number,
  months?: number,
  days?: number,
  hours?: number,
  minutes?: number,
  seconds?: number,
  ms?: number
}): number {
  if (b == null) {
    return (Date.UTC(1970, 0, 1, 0, 0, 0, 0)).valueOf();
  }
  return (Date.UTC(
    !b.years ? 1970 : b.years,
    b.months || 0,
    !b.days ? 1 : b.days + 1,
    b.hours || 0,
    b.minutes || 0,
    b.seconds || 0,
    b.ms || 0,
  )).valueOf();
}


function iso8601DatetimeFormat(date: Date): string {
  // ISO 8601 Datetime Format: YYYY-MM-DDTHH:mmZ
  const YYYY = (date.getFullYear() || 0).toString().padStart(4, '0');
  const MM = (date.getMonth() || 0).toString().padStart(2, '0');
  const DD = (date.getDate() || 0).toString().padStart(2, '0');
  return `${YYYY}-${MM}-${DD}`;
}

function isValidDate(date: Date): boolean {
  return (date.getDay() !== WeekDay.Sunday) && (date.getDay() !== WeekDay.Saturday);
}
function nextValidWeekDate(date: Date, days = 0): Date {
  if (isValidDate(date) && days <= 0) {
    return date;
  }
  return nextValidWeekDate(new Date(date.valueOf() + duration({days: 1})), days - 1);
}

export function minDataRetirada(): Date {
  return nextValidWeekDate(new Date(), 3);
}
export function minDataRetiradaStr(): String {
  return iso8601DatetimeFormat(minDataRetirada());
}

export class Order {
  public id: number = id();
  public grupos: PrintGroup[] = [];

  public isEnviando = false;
  public isEnviado = false;

  constructor(
    public name: string,
    public phone: string,
    public lojaRetirada: Store,
    public dataRetirada: Date,
  ) {
    this.name = name || '';
    this.phone = phone || '';
    this.lojaRetirada = lojaRetirada || Store.store1;
    this.dataRetirada = dataRetirada || minDataRetirada();
  }

  async getSize() {
    let size = 0;
    for (const grupo of this.grupos) {
      size += (await grupo.getSize()) || 0;
    }
    return size;
  }

  async toSubTitle() {
    return (this.phone != null ? this.phone : 'null') + '\n' +
      (this.lojaRetirada != null ? storeStr[this.lojaRetirada].name : '') + '\n' +
      iso8601DatetimeFormat(this.dataRetirada) + '\n' +
      ((await this.getSize()) / Math.pow(2, 20)).toFixed(2) + ' MB'
      ;
  }

  toString() {
    return 'name: ' + (this.name != null ? this.name : 'null') + ', ' +
      'phone: ' + (this.phone != null ? this.phone : 'null') + ', ' +
      'loja Retirada: ' + (this.lojaRetirada != null ? storeStr[this.lojaRetirada].name : '') + ', ' +
      'data Retirada: ' + iso8601DatetimeFormat(this.dataRetirada);
  }

  addGrupo(group: PrintGroup) {
    this.grupos.push(group);
    // notifyListeners();
  }
  removeGrupo(group: PrintGroup) {
    this.grupos = this.grupos.filter((g) => g.id !== group.id);
    // notifyListeners();
  }

  getStoreInfo() {
    return storeStr[this.lojaRetirada];
  }
  getFileName() {
    return `${this.name.replace(' ', '-')}_${this.phone}_${iso8601DatetimeFormat(this.dataRetirada)}_${this.id}`;
  }
  getCaption() {
    return `# Informações gerais\n` +
    `\nCliente: ${this.name}` +
    `\nTelefone: ${this.phone}` +
    `\nData da emissão: ${iso8601DatetimeFormat(new Date())}` +
    `\nData de entrega: ${iso8601DatetimeFormat(this.dataRetirada)}` +
    `\n`
    ;
  }
  getMessage() {
    let message = this.getMessage();
    for (const grupo of this.grupos) {
      message += '\n# Lote ${grupos.indexOf(grupo) + 1} ${tipoGrupoStr[grupo.tipoGrupo]}\n' + grupo.toMessage();
      for (const arquivo of grupo.arquivos) {
        message += '\nNome arquivo: ${arquivo.filename}';
      }
      message += '\n';
    }
    return message;
  }
}
