import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OffersAllComponent } from './offers-all.component';

describe('OffersAllComponent', () => {
  let component: OffersAllComponent;
  let fixture: ComponentFixture<OffersAllComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OffersAllComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(OffersAllComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
