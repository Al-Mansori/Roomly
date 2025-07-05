import { Component } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule, FormBuilder, FormGroup, Validators } from '@angular/forms';
import { UploadImageComponent } from './upload-image/upload-image.component';
import { RoomServiceService } from '../../core/services/room/room-service.service';
import Swal from 'sweetalert2';

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
  // steps = [
  //   { icon: 'Add Worksapce step indicator.png', label: 'Add Workspace', active: true },
  //   { icon: 'Add Rooms step indicator.png', label: 'Rooms', active: true },
  //   { icon: 'Add amenities step indicator.png', label: 'Amenities', active: false },
  //   { icon: 'Reception hours step indicator.png', label: 'Recipients', active: false }
  // ];

  workspaceId: string | null = null;
  roomForm: FormGroup;
  isSubmitting = false;

  constructor(
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private roomService: RoomServiceService,
    private router: Router
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
    this.route.queryParams.subscribe(params => {
      this.workspaceId = params['workspaceId'] || null;
      if (this.workspaceId) {
        console.log('تم استقبال workspaceId:', this.workspaceId);
      }
    });
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
    if (this.isSubmitting) return;

    this.roomForm.markAllAsTouched();
    if (this.roomForm.invalid) {
      this.showError('Please fill all required fields correctly');
      return;
    }

    this.isSubmitting = true;
    const staffId = this.getUserId();
    const workspaceId = this.workspaceId;

    if (!staffId || !workspaceId) {
      this.showError('Missing required information (staffId or workspaceId)');
      this.isSubmitting = false;
      return;
    }

    const roomData = this.roomForm.value;

    this.roomService.createRoom(roomData, staffId, workspaceId)
      .then(result => {
        if (result.success) {
          this.showSuccess('Room created successfully!');
          this.router.navigate(['/rooms'], { queryParams: { workspaceId } });
        }
      })
      .catch(error => {
        console.error('Error creating room:', error);
        this.showError('Failed to create room. Please try again.');
      })
      .finally(() => {
        this.isSubmitting = false;
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