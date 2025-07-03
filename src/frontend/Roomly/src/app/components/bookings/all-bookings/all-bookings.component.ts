import { BookingsListComponent } from './../bookings-list/bookings-list.component';
import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { ReservationService } from '../../../core/services/reservation/reservation.service';
import { IRequest } from '../../../interfaces/irequest';
import { IReservation } from '../../../interfaces/ireservation';



@Component({
  selector: 'app-all-bookings',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './all-bookings.component.html',
  styleUrl: './all-bookings.component.scss'
})
export class AllBookingsComponent {

  now = new Date();
  reservations: IReservation[] = [];

  constructor(
    private reservationService: ReservationService,
    private bookingsListComponent: BookingsListComponent // Access parent data
  ) { }

  ngOnInit(): void {
    this.bookingsListComponent.reservations$.subscribe({
      next: (data: IReservation[]) => {
        this.reservations = data;
      },
      error: (err) => {
        console.error('Error loading reservations:', err);
      }
    });
  }



}
