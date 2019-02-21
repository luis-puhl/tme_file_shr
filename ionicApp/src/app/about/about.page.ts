import { Component, OnInit } from '@angular/core';
import { StoreInfo, storeStr } from '@app/models/store';

@Component({
  selector: 'app-about',
  templateUrl: './about.page.html',
  styleUrls: ['./about.page.scss'],
})
export class AboutPage implements OnInit {
  storeStr: StoreInfo[] = Object.values(storeStr);

  constructor() { }

  ngOnInit() {
  }

}
