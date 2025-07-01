import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OffersExpiredComponent } from './offers-expired.component';

describe('OffersExpiredComponent', () => {
  let component: OffersExpiredComponent;
  let fixture: ComponentFixture<OffersExpiredComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OffersExpiredComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(OffersExpiredComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
