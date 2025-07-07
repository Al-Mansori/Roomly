import { OfferService } from './../../core/services/offer/offer.service';
import { RoomService } from './../../core/services/room/room.service';
import { Component, signal } from '@angular/core';
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
export class MyWorkspacesComponent {
  workspaces = signal<IWorkspace[]>([]);
  selectedWorkspace = signal<IWorkspace | null>(null);
  selectedWorkspaceRooms = signal<IRoom[]>([]);
  selectedRoom = signal<IRoom | null>(null);
  isLoading = signal(true);
  error = signal<string | null>(null);
  amenities = signal<IRoomAmenity[]>([]);
  offerForm: FormGroup;
  amenityForm: FormGroup;
  isEditingAmenity = signal(false);


  // Swiper configuration
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

  constructor(private router: Router,
    private workspaceService: WorkspaceService,
    // private authState: AuthStateService,
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
    }, { validators: this.dateRangeValidator() });
    this.amenityForm = this.fb.group({
      id: [''],
      name: ['', [Validators.required, Validators.minLength(3), Validators.maxLength(50)]],
      type: ['', Validators.required],
      description: ['', [Validators.required, Validators.minLength(10), Validators.maxLength(200)]],
      totalCount: ['', [Validators.required, Validators.min(1)]]
    });
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
    // const token = localStorage.getItem('token') || sessionStorage.getItem('token');
    // console.log('Current Token:', token);
    this.isLoading.set(true);
    this.error.set(null);

    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    console.log(staffId);

    if (!staffId) {
      this.error.set('User not authenticated');
      this.isLoading.set(false);
      this.router.navigate(['/login']);
      return;
    }

    // Use the real staffId from the logged-in user
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
    this.selectedRoom.set(null); // Reset selected room when workspace changes
    this.amenities.set([]);


    this.workspaceService.getRoomsByWorkspace(workspace.id).subscribe({
      next: (rooms) => {
        // Map the API response to match IRoom structure
        const mappedRooms = rooms.map(room => ({
          ...room,
          // roomImages: room.roomImages?.length ? room.roomImages.map(img => img.imageUrl) : null
          roomImages: room.roomImages,
          amenities: room.amenities || []

        }));
        this.selectedWorkspaceRooms.set(mappedRooms || []);
      },
      error: (err) => {
        console.error('Error fetching rooms:', err);
        this.selectedWorkspaceRooms.set([]);
        Swal.fire('Error!', 'Failed to load rooms.', 'error');
      }
    });
  }


  selectRoom(room: IRoom): void {
    console.log('Selected Room ID:', room.id); // Debug line
    console.log('Selected Room Amenitites:', room.amenities); // Debug line
    this.selectedRoom.set(room);
    this.amenities.set(room.amenities || []);

  }
  deselectRoom(): void {
    this.selectedRoom.set(null);
    this.amenities.set([]);

  }

  goToRecommendedFees(workspaceId: string): void {
    this.router.navigate(['/rooms-fees'], {
      queryParams: { workspaceId: workspaceId }
    });
  }
  private closeModal(): void {
    const modal = document.getElementById('addOfferModal');
    if (modal) {
      modal.classList.remove('show');
      document.body.classList.remove('modal-open');
      const backdrop = document.querySelector('.modal-backdrop');
      if (backdrop) backdrop.remove();
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
        this.error.set(`Failed to add offer: ${err.message || 'Please try again or contact support.'}`);
        Swal.fire('Error!', 'Failed to add offer.', 'error');
      }
    });
  }

  // Workspace Actions
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
    // Placeholder for API call (e.g., workspaceService.deleteWorkspace(workspaceId))
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
    // Placeholder for navigation or form to edit workspace
    this.router.navigate(['/edit-workspace', workspaceId]); // Adjust route as needed
  }

  showFeesRecommendations(workspaceId: string): void {
    this.goToRecommendedFees(workspaceId); // Reuse existing navigation
  }

  // Room Actions
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
    // Placeholder for API call (e.g., roomService.deleteRoom(roomId))
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
    // Placeholder for navigation or form to edit room
    this.router.navigate(['/edit-room', roomId]); // Adjust route as needed
  }

  showRoomOffers(roomId: string): void {
    // Navigate to offers list component
    this.router.navigate(['/offers', roomId]); // Adjust route as needed
  }
  fetchAmenities(roomId: string): void {
    this.isLoading.set(true);
    this.error.set(null);
    this.amenityForm.reset();
    this.isEditingAmenity.set(false);

    this.roomService.getAmenitiesByRoom(roomId).subscribe({
      next: (amenities) => {
        console.log('Fetched Amenities for Room ID', roomId, ':', amenities); // Debug line
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
    this.amenityForm.reset();
    this.isEditingAmenity.set(false);
  }

  editAmenity(amenity: IRoomAmenity): void {
    this.amenityForm.patchValue({
      id: amenity.id,
      name: amenity.name,
      type: amenity.type,
      description: amenity.description,
      totalCount: amenity.totalCount
    });
    this.isEditingAmenity.set(true);
  }
  onAddAmenity(): void {
    if (!this.amenityForm.valid || !this.selectedRoom()) return;

    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    if (!staffId) {
      this.error.set('User not authenticated. Please log in.');
      Swal.fire('Error!', 'User not authenticated.', 'error');
      return;
    }

    const amenity: IRoomAmenity = this.amenityForm.value;
    const requestBody = { ...amenity, staffId };

    if (this.isEditingAmenity()) {
      // Update Amenity
      this.roomService.updateAmenity(requestBody).subscribe({
        next: () => {
          const updatedAmenities = this.amenities().map(a => a.id === amenity.id ? { ...a, ...amenity } : a);
          this.amenities.set(updatedAmenities);
          this.updateRoomAmenities(updatedAmenities);
          this.amenityForm.reset();
          this.isEditingAmenity.set(false);
          Swal.fire('Success!', 'Amenity updated successfully.', 'success');
        },
        error: (err) => {
          console.error('Error updating amenity:', err);
          this.error.set(`Failed to update amenity: ${err.message || 'Please try again.'}`);
          Swal.fire('Error!', 'Failed to update amenity.', 'error');
        }
      });
    } else {
      // Add Amenity
      this.roomService.addAmenity(this.selectedRoom()!.id, requestBody).subscribe({
        next: (response) => {
          const newAmenity = response.body?.id ? { ...amenity, id: response.body.id } : amenity;
          const updatedAmenities = [...this.amenities(), newAmenity];
          this.amenities.set(updatedAmenities);
          this.updateRoomAmenities(updatedAmenities);
          this.amenityForm.reset();
          Swal.fire('Success!', 'Amenity added successfully.', 'success');
        },
        error: (err) => {
          console.error('Error adding amenity:', err);
          this.error.set(`Failed to add amenity: ${err.message || 'Please try again.'}`);
          Swal.fire('Error!', 'Failed to add amenity.', 'error');
        }
      });
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
  resetAmenityForm(): void {
    this.amenityForm.reset();
    this.isEditingAmenity.set(false);
  }
  resetOfferForm(): void {
    this.offerForm.reset();
    this.offerForm.patchValue({ status: 'Active' });
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




}


