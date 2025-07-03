import { Component } from '@angular/core';
import { IRequest } from '../../../interfaces/irequest';
import { ReservationService } from '../../../core/services/reservation/reservation.service';
import { AuthService } from '../../../core/services/auth/auth.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-requests',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './requests.component.html',
  styleUrl: './requests.component.scss'
})
export class RequestsComponent {
  requests: IRequest[] = []; // Explicitly typed and initialized
  staffId: string | null = null;

  constructor(
    private reservationService: ReservationService,
    private authService: AuthService // Inject auth service
  ) { }

  ngOnInit(): void {
    this.loadStaffId();
  }

  loadStaffId(): void {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    this.staffId = user?.id || null;

    if (this.staffId) {
      this.loadRequests();
    } else {
      console.error('No staffId found, user not authenticated');
    }
  }

  loadRequests(): void {
    if (!this.staffId) {
      console.error('staffId is not available');
      return;
    }

    this.reservationService.getRequestsByStaff(this.staffId).subscribe({
      next: (data: IRequest[]) => {
        this.requests = data;
      },
      error: (err) => {
        console.error('Error loading requests:', err);
      }
    });
  }

  approveRequest(requestId: string): void {
    if (!this.staffId) {
      console.error('Cannot approve: staffId not available');
      return;
    }

    this.reservationService.approveRequest(requestId).subscribe({
      next: (response) => {
        console.log('Request approved:', response);
        this.loadRequests(); // Refresh the list
      },
      error: (err) => {
        console.error('Error approving request:', err);
      }
    });
  }

  rejectRequest(requestId: string): void {
    if (!this.staffId) {
      console.error('Cannot reject: staffId not available');
      return;
    }

    this.reservationService.rejectRequest(requestId).subscribe({
      next: (response) => {
        console.log('Request rejected:', response);
        this.loadRequests(); // Refresh the list
      },
      error: (err) => {
        console.error('Error rejecting request:', err);
      }
    });
  }

}
