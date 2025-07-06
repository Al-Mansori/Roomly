import { Component, signal } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UploadImageComponent } from './upload-image/upload-image.component';
import { RoomServiceService } from '../../core/services/room/room-service.service';
import Swal from 'sweetalert2';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { IRoom } from '../../interfaces/iworkspace';
import { RoomService } from '../../core/services/room/room.service';
import { MyRoom } from '../../interfaces/isimple-room';
@Component({
  selector: 'app-add-rooms',
  standalone: true,
  imports: [
    SideStepsIndicatorComponent,
    CommonModule,
    ReactiveFormsModule,
    FormsModule,
    UploadImageComponent, 
    RouterModule
    
  ],
  templateUrl: './add-rooms.component.html',
  styleUrls: ['./add-rooms.component.scss']
})
export class AddRoomsComponent {

  workspaceId: string | null = null;
  roomForm: FormGroup;
  isSubmitting = false;

  constructor(
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private roomService: RoomServiceService,
    private router: Router,
    private WorkspaceService : WorkspaceService,
    private RoomService : RoomService
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
    ngAfterViewInit() {
      this.loadAddedRooms();
    }
  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      this.workspaceId = params['workspaceId'] || null;
      if (this.workspaceId) {
        console.log('تم استقبال workspaceId:', this.workspaceId);
      }
    });
    this.loadAddedRooms();
  }

  addedRooms: MyRoom[] = [];
  errorMessage: string = '';

  private loadAddedRooms() {
    const workspaceId = this.workspaceId;
    
    if (workspaceId) {
      this.WorkspaceService.getRoomsByWorkspace(workspaceId).subscribe({
        next: (rooms: any[]) => {
          // تحويل البيانات لتتناسب مع احتياجاتك
          this.addedRooms = rooms.map(room => ({
            id: room.id,
            name: room.name,
            mainImage: room.roomImages?.[0]?.imageUrl || './assets/Images/room03.jpg'
          }));
          this.errorMessage = '';
        },
        error: (err) => {
          console.error('Error loading rooms:', err);
          this.errorMessage = 'حدث خطأ في تحميل الغرف';
          this.addedRooms = [];
        }
      });
    } else {
      this.addedRooms = [];
    }
  }


  updateImages(imageUrls: string[]): void {
    this.roomForm.patchValue({ imageUrls });
    this.roomForm.controls['imageUrls'].markAsTouched();
  }

  private getUserId(): string {
  const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
  return user?.id || '';
  }
  createRoom(): void {
    // 1. التحقق من حالة الإرسال
    if (this.isSubmitting) return;

    // 2. التحقق من اكتمال البيانات الأساسية
    const staffId = this.getUserId();
    const workspaceId = this.workspaceId;
    
    if (!staffId || !workspaceId) {
      this.showError('Missing required information (staffId or workspaceId)');
      return;
    }

    // 3. التحقق الشامل للنموذج
    this.roomForm.markAllAsTouched();
    
    if (this.roomForm.invalid) {
      this.highlightEmptyFields();
      this.showError('Please complete all required fields correctly');
      return;
    }

    // 4. التحقق من الصور (مثال لتحسين التحقق)
    if (!this.roomForm.get('imageUrls')?.value?.length) {
      this.showError('At least one image is required');
      return;
    }

    // 5. بدء عملية الإرسال
    this.isSubmitting = true;
    const roomData = this.roomForm.value;

    this.roomService.createRoom(roomData, staffId, workspaceId)
      .then(result => {
        if (result.success) {
          this.handleSuccess(result, workspaceId);
        } else {
          this.showError('Failed to create room');
        }
      })
      .catch(error => {
        this.handleError(error);
      })
      .finally(() => {
        this.isSubmitting = false;
      });
  }

  private highlightEmptyFields(): void {
  Object.keys(this.roomForm.controls).forEach(key => {
    const control = this.roomForm.get(key);
    if (control?.invalid) {
      control.markAsTouched();
    }
  });
}

private handleSuccess(result: any, workspaceId: string): void {
  const successAlert = Swal.fire({
    icon: 'success',
    title: 'Room created successfully!',
    text: 'What would you like to do next?',
    showDenyButton: true,
    confirmButtonText: 'Add More Rooms',
    denyButtonText: 'Go to Amenities',
    reverseButtons: true,
    allowOutsideClick: false
  });

  successAlert.then((choice) => {
    if (choice.isConfirmed) {
      this.resetForm();
    } else if (choice.isDenied) {
      this.navigateToAmenities(workspaceId, result.data?.roomId);
    }
  });
}

private handleError(error: any): void {
  console.error('Error creating room:', error);
  const errorMsg = error.error?.message || 
                  error.message || 
                  'Failed to create room. Please try again.';
  this.showError(errorMsg);
}

  private resetForm(): void {
    this.roomForm.reset({
      type: 'MEETING',
      capacity: 0,
      pricePerHour: 0,
      dayPrice: 0,
      monthPrice: 0,
      priceNegotiable: false,
      active: true,
      imageUrls: []
    });
    this.loadAddedRooms();
  }

 navigateToAmenities(workspaceId: string, roomId: string): void {
  if (!roomId) {
    this.showError('Room ID is missing');
    return;
  }
  this.router.navigate(['/add-amenities'], { 
    queryParams: { 
      workspaceId: workspaceId,
      roomId: roomId
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
  // في AddRoomsComponent

editRoom(roomId: string): void {
  this.router.navigate(['/edit-room'], { 
    queryParams: { 
      workspaceId: this.workspaceId,
      roomId: roomId
    }
  });
}

deleteRoom(roomId: string): void {
  Swal.fire({
    title: 'Are you sure?',
    text: 'You won\'t be able to revert this!',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, delete it!'
  }).then((result) => {
    if (result.isConfirmed) {
      this.RoomService.deleteRoom(roomId).subscribe({
        next: () => {
          this.showSuccess('Room deleted successfully');
          this.loadAddedRooms(); // Refresh the list
        },
        error: (error) => {
          console.error('Error deleting room:', error);
          this.showError('Failed to delete room');
        }
      });
    }
  });
}


}

