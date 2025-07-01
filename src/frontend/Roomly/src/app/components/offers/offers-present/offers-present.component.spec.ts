import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OffersPresentComponent } from './offers-present.component';

describe('OffersPresentComponent', () => {
  let component: OffersPresentComponent;
  let fixture: ComponentFixture<OffersPresentComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OffersPresentComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(OffersPresentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
