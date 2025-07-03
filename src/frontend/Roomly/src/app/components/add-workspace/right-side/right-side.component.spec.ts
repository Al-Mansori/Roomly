import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RightSideComponent } from './right-side.component';

describe('RightSideComponent', () => {
  let component: RightSideComponent;
  let fixture: ComponentFixture<RightSideComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RightSideComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(RightSideComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
