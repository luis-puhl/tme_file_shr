import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { NewOrderPage, duration } from './new-order.page';

describe('NewOrderPage', () => {
  let component: NewOrderPage;
  let fixture: ComponentFixture<NewOrderPage>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ NewOrderPage ],
      schemas: [CUSTOM_ELEMENTS_SCHEMA],
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(NewOrderPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

describe('duration', () => {
  it(
    'duration vazia != vazio',
    () => expect(duration()).toEqual(duration({}))
  );

  it(
    'duration zero != vazia',
    () => expect(
      duration()
    ).toEqual(
      duration({years: 0, days: 0})
    )
  );
  it(
    'now+zero != now',
    () => expect(
      Date.now() + duration()
    ).toEqual(
      Date.now()
    )
  );
  it(
    'now+3 != now(+3)',
    () => expect(
      (Date.now() + duration({days: 3}))
    ).toEqual(
      (function() { const d = new Date(); d.setDate(d.getDate() + 3); return d; }().valueOf())
    )
  );
});
