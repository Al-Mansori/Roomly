import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NewRoomsComponent } from './new-rooms.component';

describe('NewRoomsComponent', () => {
  let component: NewRoomsComponent;
  let fixture: ComponentFixture<NewRoomsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [NewRoomsComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(NewRoomsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
