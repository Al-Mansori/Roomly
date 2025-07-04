import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component } from '@angular/core';
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
    private bookingsListComponent: BookingsListComponent, // Access parent data
    private cdr: ChangeDetectorRef
  ) { }

  ngOnInit(): void {
    // this.bookingsListComponent.reservations$.subscribe({
    //   next: (data: IReservation[]) => {
    //     this.bookings = data.filter(res =>
    //       new Date(res.startTime) > this.now && res.status.toLowerCase() !== 'cancelled'
    //     );
    //   },
    //   error: (err) => {
    //     console.error('Error loading reservations:', err);
    //   }
    // });
    this.bookingsListComponent.reservations$.subscribe({
      next: (data: IReservation[]) => {
        this.bookings = data.filter(res =>
          new Date(res.startTime) > this.now && res.status.toLowerCase() !== 'cancelled'
        );
        this.startCountdowns();
      },
      error: (err) => {
        console.error('Error loading reservations:', err);
      }
    });
    setInterval(() => {
      this.now = new Date();
      this.startCountdowns();
    }, 60000);
  }
  private countdownIntervals: { [key: string]: number } = {};

  startCountdowns(): void {
    this.clearCountdowns();
    this.cdr.detectChanges();
    this.bookings.forEach(booking => {
      const elementId = `countdown-${booking.id}`;
      const countdownTextElement = document.getElementById(`countdown-text-${booking.id}`);
      if (countdownTextElement) {
        this.countdownIntervals[booking.id] = window.setInterval(() => {
          const start = new Date(booking.startTime).getTime();
          const now = this.now.getTime();
          const timeDiff = start - now;

          if (timeDiff <= 0) {
            clearInterval(this.countdownIntervals[booking.id]);
            countdownTextElement.textContent = 'Now';
          } else {
            const days = Math.floor(timeDiff / (1000 * 60 * 60 * 24));
            const hours = Math.floor((timeDiff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((timeDiff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((timeDiff % (1000 * 60)) / 1000);
            countdownTextElement.textContent = `${days}d ${hours}h ${minutes}m ${seconds}s`;
          }
        }, 1000);
      }
    });
  }

  clearCountdowns(): void {
    Object.values(this.countdownIntervals).forEach(interval => clearInterval(interval));
    this.countdownIntervals = {};
  }
  ngOnDestroy(): void {
    this.clearCountdowns();
  }

}
