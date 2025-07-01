import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AllOffersListComponent } from './all-offers-list.component';

describe('AllOffersListComponent', () => {
  let component: AllOffersListComponent;
  let fixture: ComponentFixture<AllOffersListComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [AllOffersListComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(AllOffersListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
