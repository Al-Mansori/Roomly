import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { ReservationService } from '../../../core/services/reservation/reservation.service';
import { BookingsListComponent } from '../bookings-list/bookings-list.component';
import { IRequest } from '../../../interfaces/irequest';
import { IReservation } from '../../../interfaces/ireservation';

@Component({
  selector: 'app-upcoming-bookings',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './upcoming-bookings.component.html',
  styleUrl: './upcoming-bookings.component.scss'
})
export class UpcomingBookingsComponent {

  // bookings = this.reservations.filter(res =>
  //   new Date(res.startTime) > this.now
  // );
  bookings: IReservation[] = [];
  now = new Date();

  constructor(
    private reservationService: ReservationService,
    private bookingsListComponent: BookingsListComponent // Access parent data
  ) { }

  ngOnInit(): void {
    this.bookingsListComponent.reservations$.subscribe({
      next: (data: IReservation[]) => {
        this.bookings = data.filter(res =>
          new Date(res.startTime) > this.now && res.status.toLowerCase() !== 'cancelled'
        );
      },
      error: (err) => {
        console.error('Error loading reservations:', err);
      }
    });
  }

}
