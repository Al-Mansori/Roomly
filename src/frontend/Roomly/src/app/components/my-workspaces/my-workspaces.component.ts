import { OfferService } from './../../core/services/offer/offer.service';
import { RoomService } from './../../core/services/room/room.service';
import { Component, OnInit, signal } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { SwiperOptions } from 'swiper';
import { Router } from '@angular/router';
import { IOffer, IReview, IRoom, IRoomAmenity, IWorkspace } from '../../interfaces/iworkspace';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { HttpClientJsonpModule } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import Swal from 'sweetalert2';


@Component({
  selector: 'app-my-workspaces',
  standalone: true,
  imports: [SideNavbarComponent, ReactiveFormsModule, HttpClientJsonpModule, CommonModule],
  templateUrl: './my-workspaces.component.html',
  styleUrl: './my-workspaces.component.scss'
})
export class MyWorkspacesComponent implements OnInit {
  workspaces = signal<IWorkspace[]>([]);
  selectedWorkspace = signal<IWorkspace | null>(null);
  selectedWorkspaceRooms = signal<IRoom[]>([]);
  selectedRoom = signal<IRoom | null>(null);
  amenities = signal<IRoomAmenity[]>([]);
  isLoading = signal(true);
  error = signal<string | null>(null);
  offerForm: FormGroup;

  swiperConfig: SwiperOptions = {
    slidesPerView: 2,
    spaceBetween: 15,
    navigation: true,
    breakpoints: {
      0: { slidesPerView: 1 },
      576: { slidesPerView: 1 },
      768: { slidesPerView: 2 },
      992: { slidesPerView: 2 }
    }
  };

  constructor(
    private router: Router,
    private workspaceService: WorkspaceService,
    private fb: FormBuilder,
    private roomService: RoomService,
    private offerService: OfferService
  ) {
    this.offerForm = this.fb.group({
      offerTitle: ['', [Validators.required, Validators.minLength(5), Validators.maxLength(100)]],
      description: ['', [Validators.required, Validators.minLength(10), Validators.maxLength(500)]],
      discountPercentage: ['', [Validators.required, Validators.pattern(/^\d*\.?\d+$/), Validators.min(1), Validators.max(99)]],
      validFrom: ['', Validators.required],
      validTo: ['', Validators.required],
      status: ['Active', Validators.required]
    }, { validators: this.dateRangeValidator });
  }

  ngOnInit(): void {
    this.fetchWorkspaces();
  }

  private dateRangeValidator() {
    return (group: FormGroup) => {
      const from = group.get('validFrom')?.value;
      const to = group.get('validTo')?.value;
      if (from && to && new Date(from) > new Date(to)) {
        return { dateRangeInvalid: true };
      }
      return null;
    };
  }

  fetchWorkspaces(): void {
    this.isLoading.set(true);
    this.error.set(null);

    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    if (!staffId) {
      this.error.set('User not authenticated');
      this.isLoading.set(false);
      this.router.navigate(['/login']);
      return;
    }

    this.workspaceService.getWorkspacesByStaff(staffId).subscribe({
      next: (workspaces) => {
        this.workspaces.set(workspaces);
        if (workspaces.length > 0) {
          this.selectWorkspace(workspaces[0]);
        }
        this.isLoading.set(false);
      },
      error: (err) => {
        this.error.set('Failed to load workspaces. Please try again.');
        this.isLoading.set(false);
        console.error('Error fetching workspaces:', err);
        Swal.fire('Error!', 'Failed to load workspaces.', 'error');
      }
    });
  }

  selectWorkspace(workspace: IWorkspace): void {
    this.selectedWorkspace.set(workspace);
    this.selectedRoom.set(null);
    this.amenities.set([]);

    this.workspaceService.getRoomsByWorkspace(workspace.id).subscribe({
      next: (rooms) => {
        const mappedRooms = rooms.map(room => ({
          ...room,
          roomImages: room.roomImages,
          amenities: room.amenities || []
        }));
        this.selectedWorkspaceRooms.set(mappedRooms || []);
      },
      error: (err) => {
        console.error('Error fetching rooms:', err);
        this.selectedWorkspaceRooms.set([]);
        this.error.set('Failed to load rooms. Please try again.');
        Swal.fire('Error!', 'Failed to load rooms.', 'error');
      }
    });
  }

  selectRoom(room: IRoom): void {
    console.log('Selected Room ID:', room.id);
    this.selectedRoom.set(room);
    this.amenities.set(room.amenities || []);
  }

  deselectRoom(): void {
    this.selectedRoom.set(null);
    this.amenities.set([]);
  }

  fetchAmenities(roomId: string): void {
    this.isLoading.set(true);
    this.error.set(null);

    this.roomService.getAmenitiesByRoom(roomId).subscribe({
      next: (amenities) => {
        console.log('Fetched Amenities for Room ID', roomId, ':', amenities);
        this.amenities.set(amenities || []);
        this.isLoading.set(false);
      },
      error: (err) => {
        this.error.set('Failed to load amenities. Please try again.');
        this.isLoading.set(false);
        console.error('Error fetching amenities:', err);
        Swal.fire('Error!', 'Failed to load amenities.', 'error');
      }
    });
  }

  showAddAmenityForm(): void {
    if (this.selectedRoom() && this.selectedWorkspace()) {
      // Close the amenities modal before navigating
      const modal = document.getElementById('amenitiesModal');
      if (modal) {
        modal.classList.remove('show');
        modal.setAttribute('aria-hidden', 'true');
        modal.style.display = 'none';
        document.body.classList.remove('modal-open');
        const backdrop = document.querySelector('.modal-backdrop');
        if (backdrop) backdrop.remove();
      }

      this.router.navigate(['/add-amenities'], {
        queryParams: {
          workspaceId: this.selectedWorkspace()!.id,
          roomId: this.selectedRoom()!.id
        }
      });
    } else {
      Swal.fire('Error', 'Please select a room first', 'error');
    }
  }

  editAmenity(amenity: IRoomAmenity): void {
    if (this.selectedRoom() && this.selectedWorkspace()) {
      // Close the amenities modal before navigating
      const modal = document.getElementById('amenitiesModal');
      if (modal) {
        modal.classList.remove('show');
        modal.setAttribute('aria-hidden', 'true');
        modal.style.display = 'none';
        document.body.classList.remove('modal-open');
        const backdrop = document.querySelector('.modal-backdrop');
        if (backdrop) backdrop.remove();
      }

      this.router.navigate(['/add-amenities'], {
        queryParams: {
          workspaceId: this.selectedWorkspace()!.id,
          roomId: this.selectedRoom()!.id,
          amenityId: amenity.id
        }
      });
    } else {
      Swal.fire('Error', 'Please select a room first', 'error');
    }
  }

  confirmDeleteAmenity(amenityId: string): void {
    Swal.fire({
      title: 'Are you sure?',
      text: 'This will permanently delete the amenity!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
      if (result.isConfirmed) {
        this.deleteAmenity(amenityId);
      }
    });
  }

  deleteAmenity(amenityId: string): void {
    this.roomService.deleteAmenity(amenityId).subscribe({
      next: () => {
        const updatedAmenities = this.amenities().filter(a => a.id !== amenityId);
        this.amenities.set(updatedAmenities);
        this.updateRoomAmenities(updatedAmenities);
        Swal.fire('Deleted!', 'Amenity has been removed.', 'success');
      },
      error: (err) => {
        console.error('Error deleting amenity:', err);
        this.error.set('Failed to delete amenity. Please try again.');
        Swal.fire('Error!', 'Failed to delete amenity.', 'error');
      }
    });
  }

  private updateRoomAmenities(amenities: IRoomAmenity[]): void {
    const currentRoom = this.selectedRoom();
    if (currentRoom) {
      const updatedRoom = { ...currentRoom, amenities };
      this.selectedRoom.set(updatedRoom);
      const updatedRooms = this.selectedWorkspaceRooms().map(r => r.id === currentRoom.id ? updatedRoom : r);
      this.selectedWorkspaceRooms.set(updatedRooms);
    }
  }

  onAddOffer(): void {
    if (!this.offerForm.valid || !this.selectedRoom()) return;

    const offer: IOffer = {
      offerTitle: this.offerForm.value.offerTitle,
      description: this.offerForm.value.description,
      discountPercentage: parseFloat(this.offerForm.value.discountPercentage),
      validFrom: this.offerForm.value.validFrom,
      validTo: this.offerForm.value.validTo,
      status: this.offerForm.value.status
    };

    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    if (!staffId) {
      this.error.set('User not authenticated. Please log in.');
      Swal.fire('Error!', 'User not authenticated.', 'error');
      return;
    }

    const requestBody = {
      ...offer,
      staffId: staffId,
      roomId: this.selectedRoom()!.id
    };

    this.offerService.addOffer(requestBody).subscribe({
      next: (response) => {
        console.log('Offer added successfully:', response.body);
        const newOffer = response.body?.id ? { ...offer, id: response.body.id } : offer;
        const updatedRoom = { ...this.selectedRoom()!, offers: [...(this.selectedRoom()?.offers || []), newOffer] };
        this.selectedRoom.set(updatedRoom);
        this.offerForm.reset();
        this.offerForm.patchValue({ status: 'Active' });
        this.closeModal();
        this.selectWorkspace(this.selectedWorkspace()!);
        Swal.fire('Success!', 'Offer added successfully.', 'success');
      },
      error: (err) => {
        console.error('Error adding offer:', err);
        this.error.set(`Failed to add offer: ${err.message || 'Please try again.'}`);
        Swal.fire('Error!', 'Failed to add offer.', 'error');
      }
    });
  }

  private closeModal(): void {
    const modal = document.getElementById('addOfferModal');
    if (modal) {
      modal.classList.remove('show');
      modal.setAttribute('aria-hidden', 'true');
      modal.style.display = 'none';
      document.body.classList.remove('modal-open');
      const backdrop = document.querySelector('.modal-backdrop');
      if (backdrop) backdrop.remove();
    }
  }

  goToRecommendedFees(workspaceId: string): void {
    this.router.navigate(['/rooms-fees'], {
      queryParams: { workspaceId: workspaceId }
    });
  }

  confirmRemoveWorkspace(workspaceId: string): void {
    Swal.fire({
      title: 'Are you sure?',
      text: 'This will permanently delete the workspace!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
      if (result.isConfirmed) {
        this.removeWorkspace(workspaceId);
      }
    });
  }

  removeWorkspace(workspaceId: string): void {
    this.workspaceService.deleteWorkspace(workspaceId).subscribe({
      next: () => {
        this.workspaces.set(this.workspaces().filter(w => w.id !== workspaceId));
        this.selectedWorkspace.set(null);
        this.selectedWorkspaceRooms.set([]);
        Swal.fire('Deleted!', 'Workspace has been removed.', 'success');
      },
      error: (err) => {
        this.error.set('Failed to delete workspace. Please try again.');
        console.error('Error deleting workspace:', err);
        Swal.fire('Error!', 'Failed to delete workspace.', 'error');
      }
    });
  }

  editWorkspace(workspaceId: string): void {
    this.router.navigate(['/edit-workspace', workspaceId]);
  }

  showFeesRecommendations(workspaceId: string): void {
    this.goToRecommendedFees(workspaceId);
  }

  confirmRemoveRoom(roomId: string): void {
    Swal.fire({
      title: 'Are you sure?',
      text: 'This will permanently delete the room!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
      if (result.isConfirmed) {
        this.removeRoom(roomId);
      }
    });
  }

  removeRoom(roomId: string): void {
    this.roomService.deleteRoom(roomId).subscribe({
      next: () => {
        this.selectedWorkspaceRooms.set(this.selectedWorkspaceRooms().filter(r => r.id !== roomId));
        this.selectedRoom.set(null);
        Swal.fire('Deleted!', 'Room has been removed.', 'success');
      },
      error: (err) => {
        this.error.set('Failed to delete room. Please try again.');
        console.error('Error deleting room:', err);
        Swal.fire('Error!', 'Failed to delete room.', 'error');
      }
    });
  }

  editRoom(roomId: string): void {
    this.router.navigate(['/edit-room', roomId]);
  }

  showRoomOffers(roomId: string): void {
    this.router.navigate(['/offers', roomId]);
  }
}