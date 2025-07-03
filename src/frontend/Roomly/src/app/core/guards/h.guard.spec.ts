import { TestBed } from '@angular/core/testing';
import { CanActivateFn } from '@angular/router';

import { hGuard } from './h.guard';

describe('hGuard', () => {
  const executeGuard: CanActivateFn = (...guardParameters) => 
      TestBed.runInInjectionContext(() => hGuard(...guardParameters));

  beforeEach(() => {
    TestBed.configureTestingModule({});
  });

  it('should be created', () => {
    expect(executeGuard).toBeTruthy();
  });
});
