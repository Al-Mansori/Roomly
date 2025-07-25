import { ComponentFixture, TestBed } from '@angular/core/testing';

import { UpcomingBookingsComponent } from './upcoming-bookings.component';

describe('UpcomingBookingsComponent', () => {
  let component: UpcomingBookingsComponent;
  let fixture: ComponentFixture<UpcomingBookingsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [UpcomingBookingsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(UpcomingBookingsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
