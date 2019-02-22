import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams, HttpRequest, HttpEvent, HttpEventType } from '@angular/common/http';
import { BehaviorSubject } from 'rxjs';
import { map, tap, last, catchError} from 'rxjs/operators';
import { saveAs } from 'file-saver';

declare const JSZip;

import { API_KEYS } from '@app/environments/api-keys';

export interface HttpClientOptions {
  headers?: HttpHeaders;
  params?: HttpParams;
  // headers?: HttpHeaders | {
  //     [header: string]: string | string[];
  // };
  // params?: HttpParams | {
  //   [param: string]: string | string[];
  // };
  observe?: 'body';
  reportProgress?: boolean;
  responseType?: 'arraybuffer' | 'blob' | 'json' | 'text';
  withCredentials?: boolean;
}
@Injectable({
  providedIn: 'root'
})
export class TelegramService {
  progressPercent = new BehaviorSubject<number>(0);
  progressMessage = new BehaviorSubject<String>('');

  constructor(
    private httpClient: HttpClient,
  ) { }

  testSendDocument() {
    // -**-*-*- -------------------
    const newZip = new JSZip();
    newZip.file('Hello1.zip', 'Hello World2\n');
    const dir = newZip.folder('dir');
    dir.file('Hello.txt', 'test');
    newZip.generateAsync(
      {
        // type: 'base64',
        type: 'blob',
        compression: 'DEFLATE',
        compressionOptions: {
          level: 9,
        },
      },
    ).then(content => {
      console.log(content);
      saveAs(content, 'test.zip');
      this.sendDocument({
        chatId: API_KEYS.LOJA_QUINTINO_ID,
        document: content,
        token: API_KEYS.telegramToken,
        caption: 'test'
      }).subscribe(
        res => console.log(res),
        err => console.log(JSON.stringify(err))
      );
    });
  }

  sendDocument(args: { chatId: number, caption: String, document: File, token: String, }) {
    const {chatId, caption, document, token } = args;
    const baseUrl = 'https://api.telegram.org/bot';
    const requestUrl = `${baseUrl}${token}/sendDocument`;
    const body = {
      'chat_id': chatId,
      'caption': caption || '',
      'parse_mode': '',
      'disable_notification': '',
      'reply_to_message_id': '',
      'reply_markup': '',
    };
    const formdata: FormData = new FormData();
    for (const key in body) {
      if (body.hasOwnProperty(key)) {
        formdata.append(key, body[key]);
      }
    }
    // document.name = fileName;
    formdata.append('document', document);

    const httpOptions: HttpClientOptions = {
      headers: new HttpHeaders({
        'Content-Type': 'multipart/form-data',
      }),
      reportProgress: true,
    };
    const req = new HttpRequest('POST', requestUrl, formdata, httpOptions);
    // The `HttpClient.request` API produces a raw event stream
    // which includes start (sent), progress, and response events.
    return this.httpClient.request(req).pipe(
      map(event => this.getEventMessage(event, document)),
      tap(message => this.showProgress(message)),
      last(), // return last (completed) message to caller
      catchError(this.handleError(document)),
    );
  }
  private getEventMessage(event: HttpEvent<any>, file: File) {
    switch (event.type) {
      case HttpEventType.Sent:
        return `Uploading file "${file.name}" of size ${file.size}.`;
      case HttpEventType.UploadProgress:
        // Compute and show the % done:
        const percentDone = Math.round(100 * event.loaded / event.total);
        this.progressPercent.next(percentDone);
        return `File "${file.name}" is ${percentDone}% uploaded.`;
      case HttpEventType.Response:
        return `File "${file.name}" was completely uploaded!`;
      default:
        return `File "${file.name}" surprising upload event: ${event.type}.`;
    }
  }
  showProgress(message: any): any {
    this.progressMessage.next(message);
    console.log(message);
  }
  handleError(document: any): any {
    console.error(document);
  }
}
