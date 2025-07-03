import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WorkspacePlanComponent } from './workspace-plan.component';

describe('WorkspacePlanComponent', () => {
  let component: WorkspacePlanComponent;
  let fixture: ComponentFixture<WorkspacePlanComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [WorkspacePlanComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(WorkspacePlanComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
