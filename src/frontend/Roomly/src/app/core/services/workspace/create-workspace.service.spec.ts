import { TestBed } from '@angular/core/testing';

import { CreateWorkspaceService } from './create-workspace.service';

describe('CreateWorkspaceService', () => {
  let service: CreateWorkspaceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CreateWorkspaceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
