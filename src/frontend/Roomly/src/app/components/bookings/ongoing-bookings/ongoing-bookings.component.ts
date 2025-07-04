import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component } from '@angular/core';
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
    private bookingsListComponent: BookingsListComponent,
    private cdr: ChangeDetectorRef
  ) { }

  ngOnInit(): void {
    // this.bookingsListComponent.reservations$.subscribe({
    //   next: (data: IReservation[]) => {
    //     this.bookings = data.filter(res =>
    //       new Date(res.startTime) <= this.now && new Date(res.endTime) >= this.now
    //     );
    //   },
    //   error: (err) => {
    //     console.error('Error loading reservations:', err);
    //   }
    // });
    this.bookingsListComponent.reservations$.subscribe({
      next: (data: IReservation[]) => {
        this.bookings = data.filter(res =>
          new Date(res.startTime) <= this.now && new Date(res.endTime) >= this.now
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
    this.cdr.detectChanges(); // Ensure DOM is updated
    this.bookings.forEach(booking => {
      const elementId = `countdown-${booking.id}`;
      const countdownTextElement = document.getElementById(`countdown-text-${booking.id}`);
      if (countdownTextElement) {
        this.countdownIntervals[booking.id] = window.setInterval(() => {
          const end = new Date(booking.endTime).getTime();
          const now = this.now.getTime();
          const timeDiff = end - now;

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
      } else {
        console.warn(`Countdown element not found for booking ${booking.id}`);
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
