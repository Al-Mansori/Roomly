import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';
import { ReservationService } from '../../../core/services/reservation/reservation.service';
import { BookingsListComponent } from '../bookings-list/bookings-list.component';
import { IReservation } from '../../../interfaces/ireservation';

@Component({
  selector: 'app-history',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './history.component.html',
  styleUrl: './history.component.scss'
})
export class HistoryComponent {

  // now = new Date();
  // bookings = this.reservations.filter(res =>
  //   new Date(res.endTime) < this.now 
  //   // res.status.toLowerCase() === 'cancelled'
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
        this.bookings = data.filter(res => new Date(res.endTime) < this.now);
      },
      error: (err) => {
        console.error('Error loading reservations:', err);
      }
    });
  }

}
