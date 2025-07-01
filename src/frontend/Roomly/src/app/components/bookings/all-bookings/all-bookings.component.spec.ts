import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AllBookingsComponent } from './all-bookings.component';

describe('AllBookingsComponent', () => {
  let component: AllBookingsComponent;
  let fixture: ComponentFixture<AllBookingsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AllBookingsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(AllBookingsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
