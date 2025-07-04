import { BookingsListComponent } from './../bookings-list/bookings-list.component';
import { CommonModule } from '@angular/common';
import { ChangeDetectorRef, Component } from '@angular/core';
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
    private bookingsListComponent: BookingsListComponent, // Access parent data
    private cdr: ChangeDetectorRef
  ) { }

  // ngOnInit(): void {
  //   this.bookingsListComponent.reservations$.subscribe({
  //     next: (data: IReservation[]) => {
  //       this.reservations = data;
  //     },
  //     error: (err) => {
  //       console.error('Error loading reservations:', err);
  //     }
  //   });
  // }
  ngOnInit(): void {
    this.bookingsListComponent.reservations$.subscribe({
      next: (data: IReservation[]) => {
        this.reservations = data;
        this.startCountdowns();
      },
      error: (err) => {
        console.error('Error loading reservations:', err);
      }
    });
    // Update now every minute to keep timers accurate
    setInterval(() => {
      this.now = new Date();
      this.startCountdowns();
    }, 60000);
  }
  private countdownIntervals: { [key: string]: number } = {};

  startCountdowns(): void {
    this.clearCountdowns();
    this.cdr.detectChanges(); // Ensure DOM is updated
    this.reservations.forEach(booking => {
      const elementId = `countdown-${booking.id}`;
      const countdownElement = document.getElementById(elementId);
      const countdownTextElement = document.getElementById(`countdown-text-${booking.id}`);
      if (countdownElement && countdownTextElement) {
        this.countdownIntervals[booking.id] = window.setInterval(() => {
          const start = new Date(booking.startTime).getTime();
          const end = new Date(booking.endTime).getTime();
          const now = this.now.getTime();
          let timeDiff: number;
          let unit: string;

          if (booking.status.toLowerCase() === 'upcoming') {
            timeDiff = start - now;
            unit = 'starts';
          } else if (booking.status.toLowerCase() === 'ongoing') {
            timeDiff = end - now;
            unit = 'ends';
          } else {
            clearInterval(this.countdownIntervals[booking.id]);
            countdownTextElement.textContent = '';
            return;
          }

          if (timeDiff <= 0) {
            clearInterval(this.countdownIntervals[booking.id]);
            countdownTextElement.textContent = 'Now';
          } else {
            const days = Math.floor(timeDiff / (1000 * 60 * 60 * 24));
            const hours = Math.floor((timeDiff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((timeDiff % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((timeDiff % (1000 * 60)) / 1000);
            countdownTextElement.textContent = `${days}d ${hours}h ${minutes}m ${seconds}s ${unit}`;
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
