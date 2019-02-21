import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { WeekDay } from '@angular/common';

import { StoreInfo, storeStr, Store } from '@app/models/store';

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
  const YYYY = date.getFullYear().toString().padStart(4, '0');
  const MM = date.getMonth().toString().padStart(2, '0');
  const DD = date.getDate().toString().padStart(2, '0');
  return `${YYYY}-${MM}-${DD}`;
}

function isValidDate(date: Date): boolean {
  return (date.getDay() !== WeekDay.Sunday) && (date.getDay() !== WeekDay.Saturday);
}
function nextValidWeekDate(date: Date, days = 0): Date {
  console.log({date});
  if (isValidDate(date) && days <= 0) {
    return date;
  }
  return nextValidWeekDate(new Date(date.valueOf() + duration({days: 1})), days - 1);
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
  minDataRetirada = iso8601DatetimeFormat(nextValidWeekDate(new Date(), 3));

  pedidoForm = this.fb.group({
    nome: ['', Validators.compose([Validators.required, Validators.minLength(4)])],
    tel: ['', Validators.compose([
      Validators.required,
      (v) => {
        const regex = /(\+?55\D?)?(\D?0?\d{2}\D?)\D?(9\D?)?(\d{4}\D?\d{4})/gi;
        const value: string = v.value;
        const len = (<string>v.value).replace(/\D/g, '').length;
        const result = len >= 10 && len < 15 && regex.test(value);
        const ret = result ? null : {'tel': '+55 10 9 9865-2356'};
        // console.log(regex);
        // console.log({
        //   value, result, test: regex.test(value), ret,
        //   exec: regex.exec(value)
        // });
        return ret;
      }
    ])],
    store: [this.selectedStore, Validators.compose([Validators.required])],
    data_retirada: [this.minDataRetirada, Validators.compose([
      Validators.required,
    ])],
  });

  constructor(
    private fb: FormBuilder,
  ) { }

  ngOnInit() {
  }

  onSubmit(e) {
    if (this.pedidoForm.valid) {
      console.log(this.pedidoForm.value);
    }
  }
}
