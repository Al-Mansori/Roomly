import { TestBed } from '@angular/core/testing';

import { OfferDataService } from './offer-data.service';

describe('OfferDataService', () => {
  let service: OfferDataService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(OfferDataService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
