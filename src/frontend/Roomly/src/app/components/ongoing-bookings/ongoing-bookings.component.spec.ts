import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OngoingBookingsComponent } from './ongoing-bookings.component';

describe('OngoingBookingsComponent', () => {
  let component: OngoingBookingsComponent;
  let fixture: ComponentFixture<OngoingBookingsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OngoingBookingsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(OngoingBookingsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
