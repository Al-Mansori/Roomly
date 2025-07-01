import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReceptionHoursComponent } from './reception-hours.component';

describe('ReceptionHoursComponent', () => {
  let component: ReceptionHoursComponent;
  let fixture: ComponentFixture<ReceptionHoursComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ReceptionHoursComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ReceptionHoursComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
