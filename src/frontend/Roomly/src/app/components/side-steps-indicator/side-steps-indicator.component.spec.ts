import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SideStepsIndicatorComponent } from './side-steps-indicator.component';

describe('SideStepsIndicatorComponent', () => {
  let component: SideStepsIndicatorComponent;
  let fixture: ComponentFixture<SideStepsIndicatorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SideStepsIndicatorComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(SideStepsIndicatorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
