import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams, HttpRequest, HttpEvent, HttpEventType } from '@angular/common/http';
import { SecureStorage, SecureStorageObject } from '@ionic-native/secure-storage/ngx';
import { BehaviorSubject } from 'rxjs';
import { map, tap, last, catchError} from 'rxjs/operators';

import { Store } from '@app/models/store';
import { API_KEYS } from '@app/environments/api-keys';
import { Order, OrderStatus } from '@app/models/order';
import { TelegramService } from './telegram.service';


@Injectable({
  providedIn: 'root'
})
export class OrderService {
  order: Order;
  statusString = new BehaviorSubject<String>('');

  constructor(
    private httpClient: HttpClient,
    private secureStorage: SecureStorage,
    private telegramService: TelegramService,
  ) { }

  private getSecStorage(): Promise<SecureStorageObject> {
    return this.secureStorage.create('tme_file_share');
  }

  async getUserInfo(): Promise<{username: string, phone: string}> {
    const storage: SecureStorageObject = await this.getSecStorage();
    if (!storage) {
      return {
        username: '',
        phone: '',
      };
    }
    const username = (await storage.get('user_name')) || '';
    const phone = (await storage.get('user_phone')) || '';
    return {username, phone};
  }
  async setUserInfo(bag: { username: string, phone: string, }) {
    const storage: SecureStorageObject = await this.getSecStorage();
    if (!storage) {
      return;
    }
    await storage.set('user_name', bag.username);
    await storage.set('user_phone', bag.phone);
  }

  newOrder(bag: {name: string, phone: string, store: Store, date: Date}): any {
    this.telegramService.testSendDocument();
    this.order = new Order(bag.name, bag.phone, bag.store, bag.date);
    this.setUserInfo({
      username: bag.name,
      phone: bag.phone,
    });
  }

  enviar() {
    const chatId = this.order.getStoreInfo().chatId;
    let response;
    try {
      response = this.enviarActual(chatId);
    } catch (error) {
      this.order.isEnviado = false;
      this.statusString.next('Falha ao enviar\nTente novamente mais tarde.');
      // print(error);
    } finally {
      this.order.isEnviando = false;
    }
    return response;
  }
  async enviarActual(telegramGroupId) {
    const order: Order = this.order;
    order.isEnviando = true;

    const orderFileName = order.getFileName();

    // Archive archive = Archive();

    this.statusString.next('Verificando arquivos');
    // limit to 50MB
    if (await (order.getSize()) >= (50 * Math.pow(2, 20))) {
      order.isEnviado = false;
      order.isEnviando = false;
      this.statusString.next(
        'Falha ao enviar, tamanho do pedido excede 50MB\n' +
        'Remova alguns arquivos e tente novamente.'
      );
      return;
    }
    for (const grupo of order.grupos) {
      for (const arquivo of grupo.arquivos) {
        const duplicados = grupo.arquivos.filter((arq) => arq.filename === arquivo.filename).length;
        if (duplicados > 1 || arquivo.filename === orderFileName + '.txt') {
          arquivo.filename = duplicados.toString() + '_' + arquivo.filename;
        }
      }
    }
    for (const grupo of order.grupos) {
      for (const arquivo of grupo.arquivos) {
        const content = await arquivo.readAsBytes();
        // archive.addFile(
        //   ArchiveFile('$orderFileName/${arquivo.filename}', content.length, content)
        // );
      }
    }
    this.statusString.next('Comprimindo arquivos');
    // List<int> content = Utf8Codec().encode(message.replaceAll('\n', '\r\n'));
    // archive.addFile(
    //   ArchiveFile('$orderFileName/pedido.txt', content.length, content)
    // );

    // List<int> tempZipFile = ZipEncoder().encode(archive);
    const tempZipFile = new File(
      [new Blob([JSON.stringify(order, null, 2)], {type : 'application/json'})],
      `${orderFileName}.zip`
    );

    this.statusString.next('Enviando arquivos');

    if (API_KEYS.telegramToken == null) {
      throw new Error('Sem telegram token');
    }
    if (telegramGroupId == null) {
      throw new Error('Sem telegram group id');
    }

    const caption = order.getCaption();
    await this.telegramService.sendDocument({
      chatId: telegramGroupId,
      document: tempZipFile,
      caption: caption,
      token: API_KEYS.telegramToken,
    });
    order.isEnviado = true;
    order.isEnviando = false;
    this.statusString.next('Pedido enviado');
  }
}
