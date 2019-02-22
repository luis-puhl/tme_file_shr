import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators, FormGroup, ValidatorFn, AbstractControl } from '@angular/forms';

import { StoreInfo, storeStr, Store } from '@app/models/store';
import { minDataRetiradaStr } from '@app/models/order';
import { OrderService } from './../order.service';

export function phoneValidator(): ValidatorFn {
  return (control: AbstractControl): {[key: string]: any} | null => {
    const regex = /(\+?55\D?)?(\D?0?\d{2}\D?)\D?(9\D?)?(\d{4}\D?\d{4})/gi;
    const value: string = control.value;
    const len = (<string>control.value).replace(/\D/g, '').length;
    const result = len >= 10 && len < 15 && regex.test(value);
    const ret = result ? null : {'tel': '+55 10 9 9865-2356'};
    return ret;
  };
}

@Component({
  selector: 'app-new-order',
  templateUrl: './new-order.page.html',
  styleUrls: ['./new-order.page.scss'],
})
export class NewOrderPage implements OnInit {
  stores: StoreInfo[] = Object.values(storeStr);
  storeStr = storeStr;
  selectedStore: Store = Store.store1;
  minDataRetirada = minDataRetiradaStr();
  pedidoForm: FormGroup;

  constructor(
    private fb: FormBuilder,
    private orderService: OrderService,
  ) {
  }

  ngOnInit() {
    this.pedidoForm = this.fb.group({
      nome: ['', Validators.compose([Validators.required, Validators.minLength(4)])],
      tel: ['', Validators.compose([Validators.required, phoneValidator()])],
      store: [this.selectedStore, Validators.compose([Validators.required])],
      data_retirada: [this.minDataRetirada, Validators.compose([
        Validators.required,
      ])],
    });
    this.orderService.getUserInfo().then(userInfo => {
      this.pedidoForm.get('nome').setValue(userInfo.username);
      this.pedidoForm.get('tel').setValue(userInfo.phone);
    }).catch(() => '');
  }

  onSubmit(e) {
    if (this.pedidoForm.valid) {
      console.log(this.pedidoForm.value);
      this.orderService.newOrder(this.pedidoForm.value);
      this.orderService.enviar();
    }
  }
}
