import { OfferService } from './../../core/services/offer/offer.service';
import { RoomService } from './../../core/services/room/room.service';
import { Component, signal } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { SwiperOptions } from 'swiper';
import { Router } from '@angular/router';
import { IOffer, IReview, IRoom, IWorkspace } from '../../interfaces/iworkspace';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { AuthStateService } from '../../core/services/auth-state/auth-state.service';
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
  // selectedWorkspaceReviews = signal<IReview[]>([]);
  isLoading = signal(true);
  error = signal<string | null>(null);
  offerForm: FormGroup;


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
      offerTitle: ['', Validators.required],
      description: ['', Validators.required],
      discountPercentage: ['', [Validators.required, Validators.pattern(/^\d*\.?\d+$/), Validators.min(0), Validators.max(100)]],
      validFrom: ['', Validators.required],
      validTo: ['', Validators.required],
      status: ['Active'] // Default status as per example
    });
  }
  ngOnInit(): void {
    this.fetchWorkspaces();
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
        console.log(staffId)
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
      }
    });
  }

  selectWorkspace(workspace: IWorkspace): void {
    this.selectedWorkspace.set(workspace);
    this.selectedRoom.set(null); // Reset selected room when workspace changes

    this.workspaceService.getRoomsByWorkspace(workspace.id).subscribe({
      next: (rooms) => {
        // Map the API response to match IRoom structure
        const mappedRooms = rooms.map(room => ({
          ...room,
          // roomImages: room.roomImages?.length ? room.roomImages.map(img => img.imageUrl) : null
          roomImages: room.roomImages
        }));
        this.selectedWorkspaceRooms.set(mappedRooms || []);
      },
      error: (err) => {
        console.error('Error fetching rooms:', err);
        this.selectedWorkspaceRooms.set([]);
      }
    });
  }


  selectRoom(room: IRoom): void {
    this.selectedRoom.set(room);
  }
  deselectRoom(): void {
    this.selectedRoom.set(null);
  }




  // navigateToOffers(workspaceId: string): void {
  //   this.router.navigate(['/offers', workspaceId]);
  // }

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

  // onAddOffer(): void {
  //   if (this.offerForm.valid && this.selectedRoom()) {
  //     const offer: IOffer = {
  //       // id: '', // Will be generated by the API
  //       offerTitle: this.offerForm.value.offerTitle,
  //       description: this.offerForm.value.description,
  //       discountPercentage: parseFloat(this.offerForm.value.discountPercentage),
  //       validFrom: this.offerForm.value.validFrom,
  //       validTo: this.offerForm.value.validTo,
  //       status: this.offerForm.value.status
  //     };

  //     const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
  //     const staffId = user?.id || 'stf001';

  //     this.roomService.addOffer(staffId, this.selectedRoom()!.id, offer).subscribe({
  //       next: (response) => {
  //         console.log('Offer added successfully:', response);
  //         this.offerForm.reset();
  //         this.offerForm.patchValue({ status: 'Active' }); // Reset to default status
  //         document.getElementById('addOfferModal')?.classList.remove('show');
  //         document.body.classList.remove('modal-open');
  //         document.querySelector('.modal-backdrop')?.remove();
  //         this.selectWorkspace(this.selectedWorkspace()!);
  //       },
  //       error: (err) => {
  //         console.error('Error adding offer:', err);
  //         this.error.set('Failed to add offer. Please try again.');
  //       }
  //     });
  //   }
  // }
  // onAddOffer(): void {
  //   if (this.offerForm.valid && this.selectedRoom()) {
  //     const offer: IOffer = {
  //       offerTitle: this.offerForm.value.offerTitle,
  //       description: this.offerForm.value.description,
  //       discountPercentage: parseFloat(this.offerForm.value.discountPercentage),
  //       validFrom: this.offerForm.value.validFrom,
  //       validTo: this.offerForm.value.validTo,
  //       status: this.offerForm.value.status
  //     };

  //     const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
  //     const staffId = user?.id;
  //     if (!staffId) {
  //       this.error.set('User not authenticated. Please log in.');
  //       return;
  //     }

  //     this.roomService.addOffer(staffId, this.selectedRoom()!.id, offer).subscribe({
  //       next: (response) => {
  //         //   if (response.id) {
  //         //     const updatedRoom = { ...this.selectedRoom()!, offers: [...(this.selectedRoom()?.offers || []), { ...offer, id: response.id }] };
  //         //     this.selectedRoom.set(updatedRoom);
  //         //   } else {
  //         //     const updatedRoom = { ...this.selectedRoom()!, offers: [...(this.selectedRoom()?.offers || []), offer] };
  //         //     this.selectedRoom.set(updatedRoom);
  //         //   }
  //         //   this.offerForm.reset();
  //         //   this.offerForm.patchValue({ status: 'Active' });
  //         //   this.closeModal();
  //         //   this.selectWorkspace(this.selectedWorkspace()!);
  //         // 
  //         console.log('Offer added successfully:', response);
  //         const newOffer = response.id ? { ...offer, id: response.id } : offer;
  //         const updatedRoom = { ...this.selectedRoom()!, offers: [...(this.selectedRoom()?.offers || []), newOffer] };
  //         this.selectedRoom.set(updatedRoom);
  //         this.offerForm.reset();
  //         this.offerForm.patchValue({ status: 'Active' });
  //         this.closeModal();
  //         this.selectWorkspace(this.selectedWorkspace()!); // Refresh workspace to reflect changes
  //       },
  //       error: (err) => {
  //         console.error('Error adding offer:', err);
  //         this.error.set(`Failed to add offer: ${err.message || 'Please try again or contact the backend team.'}`);
  //       }
  //     });
  //   }
  // }
  async onAddOffer(): Promise<void> {
    if (!this.offerForm.valid || !this.selectedRoom()) return;

    try {
      const user = JSON.parse(sessionStorage.getItem('user') || '{}');
      const offerData = {
        offerTitle: this.offerForm.value.offerTitle,
        description: this.offerForm.value.description,
        discountPercentage: +this.offerForm.value.discountPercentage,
        validFrom: this.offerForm.value.validFrom,
        validTo: this.offerForm.value.validTo,
        status: this.offerForm.value.status
      };

      const response = await this.offerService.createOffer(
        user.id,
        this.selectedRoom()!.id,
        offerData
      ).toPromise();

      this.handleSuccess(response);
    } catch (error) {
      this.handleError(error);
    }
  }

  private handleSuccess(response: any): void {
    console.log('Offer created:', response);
    // Update your UI state here
    this.offerForm.reset();
    this.closeModal();
  }

  private handleError(error: any): void {
    console.error('Offer creation failed:', error);
    this.error.set(this.getErrorMessage(error));
  }

  private getErrorMessage(error: any): string {
    if (error.status === 403) {
      return 'You do not have permission to create offers';
    }
    return error.message || 'Failed to create offer. Please try again.';
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

}
