import { Component } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { UploadImageComponent } from './upload-image/upload-image.component';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { AmenityService } from '../../core/services/amenity/amenity.service';
import { CommonModule } from '@angular/common';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-add-amenities',
  standalone: true,
  imports: [
    CommonModule,
    SideStepsIndicatorComponent,
    RouterModule,
    UploadImageComponent,
    ReactiveFormsModule
  ],
  templateUrl: './add-amenities.component.html',
  styleUrls: ['./add-amenities.component.scss']
})
export class AddAmenitiesComponent {
  workspaceId: string | null = null;
  roomId: string | null = null;
  amenityForm: FormGroup;
  addedRooms: any[] = [];
  errorMessage: string = '';
  selectedRoomId: string | null = null;

  constructor(
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private router: Router,
    private workspaceService: WorkspaceService,
    private amenityService: AmenityService
  ) {
    this.amenityForm = this.fb.group({
      name: ['', [Validators.required, Validators.maxLength(50)]],
      type: ['Equipment', Validators.required],
      description: ['', [Validators.required, Validators.maxLength(110)]],
      totalCount: [1, [Validators.required, Validators.min(1)]],
      availableCount: [1, [Validators.required, Validators.min(0)]],
      imageUrls: [[], [Validators.required, Validators.minLength(1)]]
    });
  }

  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      this.workspaceId = params['workspaceId'] || null;
      this.roomId = params['roomId'] || null;
      
      if (this.workspaceId) {
        console.log('Workspace ID:', this.workspaceId);
        this.loadAddedRooms();
      }
      
      if (this.roomId) {
        console.log('Room ID:', this.roomId);
        this.selectedRoomId = this.roomId;
      }
    });
  }

  updateImages(imageUrls: string[]): void {
    this.amenityForm.patchValue({ imageUrls });
    this.amenityForm.controls['imageUrls'].markAsTouched();
  }

  private loadAddedRooms() {
    if (this.workspaceId) {
      this.workspaceService.getRoomsByWorkspace(this.workspaceId).subscribe({
        next: (rooms: any[]) => {
          this.addedRooms = rooms.map(room => ({
            id: room.id,
            name: room.name,
            mainImage: room.roomImages?.[0]?.imageUrl || './assets/Images/room03.jpg'
          }));
          this.errorMessage = '';
        },
        error: (err) => {
          console.error('Error loading rooms:', err);
          this.errorMessage = 'Error loading rooms';
          this.addedRooms = [];
        }
      });
    }
  }

selectRoom(roomId: string, roomName: string) {
  Swal.fire({
    title: 'Add Amenity',
    html: `Do you want to add an amenity to the room <b>${roomName}</b>?`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: 'Yes, add amenity',
    cancelButtonText: 'Cancel',
    customClass: {
      confirmButton: 'btn btn-primary mx-2',
      cancelButton: 'btn btn-secondary mx-2'
    },
    buttonsStyling: false
  }).then((result) => {
    if (result.isConfirmed) {
      this.selectedRoomId = roomId;
      // You can add any additional action here on confirmation
    }
  });
}


onSubmit() {
    if (this.amenityForm.invalid || !this.selectedRoomId) {
      this.amenityForm.markAllAsTouched();
      Swal.fire('Error', 'Please fill all required fields and select a room', 'error');
      return;
    }

    const formData = {
      ...this.amenityForm.value,
      roomId: this.selectedRoomId,
      staffId: this.getStaffId()
    };

    this.amenityService.createAmenity(formData).subscribe({
      next: (response) => {
        Swal.fire({
          title: 'Success!',
          text: 'Amenity added successfully!',
          icon: 'success',
          showCancelButton: true,
          confirmButtonText: 'Add Reception Hours',
          cancelButtonText: 'Continue Adding Amenities',
          reverseButtons: true
        }).then((result) => {
          if (result.isConfirmed) {
            // الانتقال إلى صفحة Reception Hours
            this.router.navigate(['/reception-hours'], {
              queryParams: {
                workspaceId: this.workspaceId,
                roomId: this.selectedRoomId
              }
            });
          } else {
            this.amenityForm.reset();
            this.updateImages([]);
            this.selectedRoomId = null; 
          }
        });
      },
      error: (error) => {
        console.error('Error creating amenity:', error);
        Swal.fire('Error', 'Failed to add amenity', 'error');
      }
    });
  }

  private getStaffId(): string {
  const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
  return user?.id || '';
  }
    getErrorMessage(field: string): string {
    const control = this.amenityForm.get(field);
    if (!control || !control.errors) return '';

    if (control.hasError('required')) {
      return 'This field is required';
    } else if (control.hasError('maxlength')) {
      return `Maximum length is ${control.errors['maxlength'].requiredLength} characters`;
    } else if (control.hasError('min')) {
      return `Minimum value is ${control.errors['min'].min}`;
    } else if (control.hasError('max')) {
      return `Maximum value is ${control.errors['max'].max}`;
    } else if (control.hasError('minLength')) {
      return `At least ${control.errors['minLength'].requiredLength} image is required`;
    }
    return 'Invalid value';
  }

    isFieldInvalid(field: string): boolean {
    const control = this.amenityForm.get(field);
    return control ? control.invalid && (control.dirty || control.touched) : false;
  }


}