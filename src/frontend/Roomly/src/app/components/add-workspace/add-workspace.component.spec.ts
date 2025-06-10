import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddWorkspaceComponent } from './add-workspace.component';

describe('AddWorkspaceComponent', () => {
  let component: AddWorkspaceComponent;
  let fixture: ComponentFixture<AddWorkspaceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AddWorkspaceComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(AddWorkspaceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
