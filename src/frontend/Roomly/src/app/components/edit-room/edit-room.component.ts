import { Component, OnInit } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UploadImageComponent } from '../add-rooms/upload-image/upload-image.component';
import { RoomService } from '../../core/services/room/room.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-edit-room',
  standalone: true,
  imports: [
    SideStepsIndicatorComponent,
    CommonModule,
    ReactiveFormsModule,
    FormsModule,
    UploadImageComponent, 
    RouterModule
  ],
  templateUrl: './edit-room.component.html',
  styleUrls: ['./edit-room.component.scss']
})
export class EditRoomComponent implements OnInit {
  roomId: string | null = null;
  workspaceId: string | null = null;
  roomForm: FormGroup;
  isSubmitting = false;
  initialImages: string[] = [];

  constructor(
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private router: Router,
    private roomService: RoomService
  ) {
    this.roomForm = this.fb.group({
      name: ['', [Validators.required, Validators.maxLength(50)]],
      type: ['MEETING', Validators.required],
      description: ['', [Validators.required, Validators.maxLength(110)]],
      capacity: [0, [Validators.required, Validators.min(1), Validators.max(100)]],
      pricePerHour: [0, [Validators.required, Validators.min(1)]],
      dayPrice: [0, [Validators.min(0)]],
      monthPrice: [0, [Validators.min(0)]],
      priceNegotiable: [false],
      active: [true],
      imageUrls: [[], [Validators.required, Validators.minLength(1)]]
    });
  }

ngOnInit() {
  this.route.paramMap.subscribe(params => {
    this.roomId = params.get('id');
    console.log('Received roomId in edit page:', this.roomId);

    // 👇 استدعاء تحميل البيانات بعد ما نتأكد إن roomId جه
    if (this.roomId) {
      this.loadRoomData(this.roomId);
    }
  });

  this.route.queryParamMap.subscribe(queryParams => {
    this.workspaceId = queryParams.get('workspaceId');
    console.log('Received workspaceId in edit page:', this.workspaceId);
  });
}


  private loadRoomData(roomId: string): void {
    this.roomService.getRoomById(roomId).subscribe({
      next: (room: any) => {
        this.initialImages = room.roomImages?.map((img: any) => img.imageUrl) || [];
        
        this.roomForm.patchValue({
          name: room.name,
          type: room.type,
          description: room.description,
          capacity: room.capacity,
          pricePerHour: room.pricePerHour,
          dayPrice: room.dayPrice || 0,
          monthPrice: room.monthPrice || 0,
          priceNegotiable: room.priceNegotiable || false,
          active: room.status === 'AVAILABLE',
          imageUrls: this.initialImages
        });
      },
      error: (error) => {
        console.error('Error loading room:', error);
        this.showError('Failed to load room data');
        this.router.navigate(['/']);
      }
    });
  }

  updateImages(imageUrls: string[]): void {
    this.roomForm.patchValue({ imageUrls });
    this.roomForm.controls['imageUrls'].markAsTouched();
  }

  updateRoom(): void {
    if (this.isSubmitting || !this.roomId) return;

    this.roomForm.markAllAsTouched();
    
    if (this.roomForm.invalid) {
      this.highlightEmptyFields();
      this.showError('Please complete all required fields correctly');
      return;
    }

    if (!this.roomForm.get('imageUrls')?.value?.length) {
      this.showError('At least one image is required');
      return;
    }

    this.isSubmitting = true;
    const roomData = this.roomForm.value;
    const staffId = this.getUserId();

    this.roomService.updateRoom(this.roomId, roomData, staffId).subscribe({
      next: () => {
          Swal.fire({
            icon: 'success',
            title: 'Room updated successfully!',
            text: 'Do you want to add another room to this workspace?',
            showCancelButton: true,
            confirmButtonText: 'Yes, add room',
            cancelButtonText: 'No, back to workspaces',
          }).then(result => {
            if (result.isConfirmed && this.workspaceId) {
              this.router.navigate(['/add-rooms'], { 
                queryParams: { workspaceId: this.workspaceId } 
              });
            } else {
              this.router.navigate(['/my-workspaces']);
            }
          });
      },
      error: (error) => {
        console.error('Error updating room:', error);
        this.showError('Failed to update room. Please try again.');
      },
      complete: () => {
        this.isSubmitting = false;
      }
    });
  }

  deleteRoom(): void {
    if (!this.roomId) return;

    Swal.fire({
      title: 'Are you sure?',
      text: 'You won\'t be able to revert this!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#3085d6',
      cancelButtonColor: '#d33',
      confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
      if (result.isConfirmed && this.roomId) {
        this.roomService.deleteRoom(this.roomId).subscribe({
          next: () => {
            this.showSuccess('Room deleted successfully');
            if (this.workspaceId) {
              this.router.navigate(['/add-rooms'], { 
                queryParams: { workspaceId: this.workspaceId } 
              });
            }
          },
          error: (error) => {
            console.error('Error deleting room:', error);
            this.showError('Failed to delete room');
          }
        });
      }
    });
  }

  private getUserId(): string {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    return user?.id || '';
  }

  private highlightEmptyFields(): void {
    Object.keys(this.roomForm.controls).forEach(key => {
      const control = this.roomForm.get(key);
      if (control?.invalid) {
        control.markAsTouched();
      }
    });
  }

  private showSuccess(message: string): void {
    Swal.fire({
      icon: 'success',
      title: 'Success!',
      text: message,
      timer: 3000,
      showConfirmButton: false
    });
  }

  private showError(message: string): void {
    Swal.fire({
      icon: 'error',
      title: 'Error!',
      text: message,
      timer: 3000
    });
  }

  isFieldInvalid(field: string): boolean {
    const control = this.roomForm.get(field);
    return control ? control.invalid && (control.dirty || control.touched) : false;
  }

  getErrorMessage(field: string): string {
    const control = this.roomForm.get(field);
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
}