import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OffersRecommendationsComponent } from './offers-recommendations.component';

describe('OffersRecommendationsComponent', () => {
  let component: OffersRecommendationsComponent;
  let fixture: ComponentFixture<OffersRecommendationsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [OffersRecommendationsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(OffersRecommendationsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
