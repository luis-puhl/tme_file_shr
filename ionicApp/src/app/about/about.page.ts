import { Component, OnInit } from '@angular/core';
import { LojaInfo, lojaStr } from '@app/models/loja';

@Component({
  selector: 'app-about',
  templateUrl: './about.page.html',
  styleUrls: ['./about.page.scss'],
})
export class AboutPage implements OnInit {
  lojaStr: LojaInfo[] = Object.values(lojaStr);

  constructor() { }

  ngOnInit() {
  }

}
