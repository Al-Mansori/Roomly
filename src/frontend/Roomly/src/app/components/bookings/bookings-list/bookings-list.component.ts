import { WorkspaceService } from './../../../core/services/workspace/workspace.service';
import { Component } from '@angular/core';
import { SideNavbarComponent } from "../../side-navbar/side-navbar.component";
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { ReservationService } from '../../../core/services/reservation/reservation.service';
import { BehaviorSubject } from 'rxjs';
import { AuthService } from '../../../core/services/auth/auth.service';
import { IReservation } from '../../../interfaces/ireservation';
import { FormsModule } from '@angular/forms';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-bookings-list',
  standalone: true,
  imports: [SideNavbarComponent, RouterOutlet, RouterLink, RouterLinkActive, FormsModule],
  templateUrl: './bookings-list.component.html',
  styleUrl: './bookings-list.component.scss'
})
export class BookingsListComponent {
  staffId: string | null = null;
  private reservationsSubject = new BehaviorSubject<IReservation[]>([]);
  reservations$ = this.reservationsSubject.asObservable();
  showCreateForm = false;
  formData = {
    startTime: '',
    endTime: '',
    amenitiesCount: 1,
    workspaceName: '',
    roomName: ''
  };
  workspaces: { id: string; name: string }[] = [];
  rooms: { id: string; name: string }[] = [];
  selectedWorkspaceId: string | null = null;

  constructor(
    private reservationService: ReservationService,
    private authService: AuthService,
    private workspaceService: WorkspaceService
  ) { }

  ngOnInit(): void {
    this.loadStaffId();
    this.loadWorkspaces();
  }

  loadStaffId(): void {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    this.staffId = user?.id || null;

    if (this.staffId) {
      this.loadReservations();
    } else {
      console.error('No staffId found, user not authenticated');
    }
  }

  loadReservations(): void {
    if (!this.staffId) {
      console.error('staffId is not available');
      return;
    }

    this.reservationService.getReservationsByStaff(this.staffId).subscribe({
      next: (data: IReservation[]) => {
        this.reservationsSubject.next(data);
      },
      error: (err) => {
        console.error('Error loading reservations:', err);
      }
    });
  }
  loadWorkspaces(): void {
    if (!this.staffId) {
      console.error('staffId not available');
      return;
    }

    this.workspaceService.getWorkspacesByStaff(this.staffId).subscribe({
      next: (data) => {
        this.workspaces = data.map(w => ({ id: w.id, name: w.name }));
      },
      error: (err) => {
        console.error('Error loading workspaces:', err);
      }
    });
  }

  onWorkspaceChange(): void {
    if (this.formData.workspaceName) {
      const selectedWorkspace = this.workspaces.find(w => w.name === this.formData.workspaceName);
      this.selectedWorkspaceId = selectedWorkspace ? selectedWorkspace.id : null;
      this.loadRooms();
    } else {
      this.rooms = [];
      this.selectedWorkspaceId = null;
    }
  }

  loadRooms(): void {
    if (this.selectedWorkspaceId) {
      this.workspaceService.getRoomsByWorkspace(this.selectedWorkspaceId!).subscribe({
        next: (roomData) => {
          this.rooms = roomData.map(r => ({ id: r.id, name: r.name }));
        },
        error: (err) => {
          console.error('Error loading rooms:', err);
        }
      });
    } else {
      this.rooms = [];
    }
  }
  openCreateForm(): void {
    this.showCreateForm = true;
    this.loadWorkspaces(); // Ensure workspaces are loaded when form opens
  }

  createReservation(): void {
    if (!this.staffId || !this.formData.startTime || !this.formData.endTime || !this.formData.amenitiesCount || !this.selectedWorkspaceId || !this.formData.roomName) {
      console.error('All fields are required');
      return;
    }

    const selectedRoom = this.rooms.find(r => r.name === this.formData.roomName);
    if (!selectedRoom) {
      console.error('Invalid room selection');
      return;
    }

    this.reservationService.createReservation(
      this.formData.startTime,
      this.formData.endTime,
      this.formData.amenitiesCount,
      this.selectedWorkspaceId,
      selectedRoom.id
    ).subscribe({
      next: (response) => {
        console.log('Reservation created:', response);
        this.showCreateForm = false;
        this.loadReservations(); // Refresh the list
        this.formData = { startTime: '', endTime: '', amenitiesCount: 1, workspaceName: '', roomName: '' }; // Reset form
        Swal.fire('Success!', 'Reservation created successfully!', 'success');
      },
      error: (err) => {
        console.error('Error creating reservation:', err);
        Swal.fire('Error!', 'Failed to create reservation.', 'error');
      }
    });
  }

  cancelCreate(): void {
    this.showCreateForm = false;
    this.formData = { startTime: '', endTime: '', amenitiesCount: 1, workspaceName: '', roomName: '' }; // Reset form
    this.rooms = [];
    this.selectedWorkspaceId = null;
  }
}
