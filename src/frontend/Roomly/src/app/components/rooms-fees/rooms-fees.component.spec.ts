import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RoomsFeesComponent } from './rooms-fees.component';

describe('RoomsFeesComponent', () => {
  let component: RoomsFeesComponent;
  let fixture: ComponentFixture<RoomsFeesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RoomsFeesComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(RoomsFeesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
