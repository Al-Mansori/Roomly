import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { IReservation } from '../../../interfaces/ireservation';
import { ReservationService } from '../../../core/services/reservation/reservation.service';
import { BookingsListComponent } from '../bookings-list/bookings-list.component';

@Component({
  selector: 'app-ongoing-bookings',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './ongoing-bookings.component.html',
  styleUrl: './ongoing-bookings.component.scss'
})
export class OngoingBookingsComponent {
  //   now = new Date();


  // bookings = this.reservations.filter(res =>
  //   new Date(res.startTime) <= this.now &&
  //   new Date(res.endTime) >= this.now
  // );
  bookings: IReservation[] = [];
  now = new Date();

  constructor(
    private reservationService: ReservationService,
    private bookingsListComponent: BookingsListComponent
  ) { }

  ngOnInit(): void {
    this.bookingsListComponent.reservations$.subscribe({
      next: (data: IReservation[]) => {
        this.bookings = data.filter(res =>
          new Date(res.startTime) <= this.now && new Date(res.endTime) >= this.now
        );
      },
      error: (err) => {
        console.error('Error loading reservations:', err);
      }
    });
  }


}
