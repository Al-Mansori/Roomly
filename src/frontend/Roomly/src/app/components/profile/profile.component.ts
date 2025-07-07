import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import Swal from 'sweetalert2';
import { CustomerService } from '../../core/services/customer/customer.service';

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [SideNavbarComponent, CommonModule, FormsModule, ReactiveFormsModule],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss'
})
export class ProfileComponent implements OnInit {
  staffData: any = {};
  isLoading = true;
  isEditing = false;
  profileForm: FormGroup;
  staffTypes = ['DEFAULT', 'ADMIN', 'WORKER', 'MANGER'];

  constructor(
    private staffService: CustomerService,
    private fb: FormBuilder
  ) {
    this.profileForm = this.fb.group({
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', Validators.required],
      userType: ['', Validators.required], // This is the selectable type (MANGER, etc.)
      // Protected fields
      id: [''],
      password: ['']
    });
  }

  ngOnInit(): void {
    this.loadStaffData(this.getUserId());
  }

  private getUserId(): string {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    return user?.id || '';
  }

  loadStaffData(staffId: string): void {
    this.staffService.getStaffDetails(staffId).subscribe({
      next: (data) => {
        this.staffData = data;
        // Set form values including protected fields
        this.profileForm.patchValue({
          firstName: data.firstName,
          lastName: data.lastName,
          email: data.email,
          phone: data.phone,
          userType: data.type, // The selectable type (MANGER, etc.)
          id: data.id,
          password: data.password
        });
        this.isLoading = false;
      },
      error: (error: any) => {
        console.error('Error fetching staff data:', error);
        this.isLoading = false;
        Swal.fire({
          icon: 'error',
          title: 'Error!',
          text: 'Failed to load profile data',
          timer: 3000
        });
      }
    });
  }

  toggleEdit(): void {
    this.isEditing = !this.isEditing;
    if (!this.isEditing) {
      // Reset form to original values when canceling edit
      this.profileForm.patchValue({
        firstName: this.staffData.firstName,
        lastName: this.staffData.lastName,
        email: this.staffData.email,
        phone: this.staffData.phone,
        userType: this.staffData.type
      });
    }
  }

saveProfile(): void {
  if (this.profileForm.valid) {
    this.isLoading = true;
    
    // Prepare payload with exactly the structure you specified
    const payload = {
      firstName: this.profileForm.value.firstName,
      lastName: this.profileForm.value.lastName,
      email: this.profileForm.value.email,
      password: this.profileForm.value.password,
      phone: this.profileForm.value.phone,
      type: this.profileForm.value.userType, // Map userType to type
      id: this.profileForm.value.id
    };

    this.staffService.updateStaffProfile(payload).subscribe({
      next: (response) => {
        // Update local data with new values
        this.staffData = { 
          ...this.staffData,
          firstName: this.profileForm.value.firstName,
          lastName: this.profileForm.value.lastName,
          email: this.profileForm.value.email,
          phone: this.profileForm.value.phone,
          type: this.profileForm.value.userType // Update type here as well
        };
        
        this.isEditing = false;
        this.isLoading = false;
        Swal.fire({
          icon: 'success',
          title: 'Success!',
          text: 'Profile updated successfully',
          timer: 3000
        });
      },
      error: (error) => {
        console.error('Error updating profile:', error);
        this.isLoading = false;
        Swal.fire({
          icon: 'error',
          title: 'Error!',
          text: 'Failed to update profile',
          timer: 3000
        });
      }
    });
  } else {
    Swal.fire({
      icon: 'warning',
      title: 'Validation Error',
      text: 'Please fill all required fields correctly',
      timer: 3000
    });
  }
}
}
import { SideNavbarComponent } from '../side-navbar/side-navbar.component';
