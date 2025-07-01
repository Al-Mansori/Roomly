import { AuthStateService } from './../../core/services/auth-state/auth-state.service';
import { Component, inject } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule, FormControl, AbstractControl } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { AuthService } from '../../core/services/auth/auth.service';

type RegisterForm = {
  firstName: FormControl<string | null>;
  lastName: FormControl<string | null>;
  email: FormControl<string | null>;
  phone: FormControl<string | null>;
  password: FormControl<string | null>;
  confirmPassword: FormControl<string | null>;
  terms: FormControl<boolean | null>;
};

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [ReactiveFormsModule, CommonModule],
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.scss']
})
export class RegisterComponent {

  private readonly fb = inject(FormBuilder);
  private readonly authService = inject(AuthService);
  private readonly router = inject(Router);
  private readonly authState = inject(AuthStateService);

  registerForm: FormGroup<RegisterForm>;
  isLoading = false;
  errorMessage = '';
  successMessage = '';
  showSuccess = false;
  userId = '';
  email = '';

  constructor() {
    this.registerForm = this.fb.group({
      firstName: ['', [Validators.required, Validators.minLength(2)]],
      lastName: ['', [Validators.required, Validators.minLength(2)]],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', [Validators.required, Validators.pattern(/^[0-9]{10,15}$/)]],
      password: ['', [
        Validators.required,
        Validators.minLength(10),
        Validators.pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{10,}$/)
      ]],
      confirmPassword: ['', [Validators.required]],
      terms: [false, [Validators.requiredTrue]]
    }, { validators: this.passwordMatchValidator });
  }

  private passwordMatchValidator(group: AbstractControl) {
    const formGroup = group as FormGroup<RegisterForm>;
    const password = formGroup.controls.password.value;
    const confirmPassword = formGroup.controls.confirmPassword.value;

    if (password !== confirmPassword) {
      formGroup.controls.confirmPassword.setErrors({ mismatch: true });
      return { mismatch: true };
    } else {
      formGroup.controls.confirmPassword.setErrors(null);
      return null;
    }
  }

  onSubmit(): void {
    // Check if passwords match before submission
    if (this.registerForm.hasError('mismatch')) {
      this.errorMessage = 'Passwords do not match';
      return;
    }

    if (this.registerForm.invalid) {
      this.registerForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';
    this.successMessage = '';
    this.showSuccess = false;

    const formValue = this.registerForm.getRawValue();

    const formData = {
      firstName: formValue.firstName || '',
      lastName: formValue.lastName || '',
      email: formValue.email || '',
      password: formValue.password || '',
      confirmPassword: formValue.confirmPassword || '',
      phone: formValue.phone || '',
      staff: true
    };

    this.authService.registerStaff(formData).subscribe({
      next: (res) => {
        this.isLoading = false;
        if (res.registrationStatus) {
          // this.authState.setOtpData(formData.email, res.userId);
          this.authState.setOtpData(formData.email, res.userId, formData);
          this.successMessage = 'Registration successful! Please check your email for OTP.';
          this.showSuccess = true;
          this.userId = res.userId;
          this.email = formData.email;

          // Close register modal and open OTP modal with query params
          this.closeModal('registerModal');

          // Add query params to URL
          this.router.navigate([], {
            queryParams: {
              email: this.email,
              userId: this.userId,
              showOtpModal: true
            },
            queryParamsHandling: 'merge'
          });

          // Open OTP modal after a short delay
          setTimeout(() => this.openOtpModal(), 500);
        }

        else {
          this.errorMessage = 'Registration failed. Please try again.';
        }
      },
      error: (error) => {
        this.isLoading = false;

        if (error.error?.error === 'Passwords do not match.') {
          this.errorMessage = 'Passwords do not match';
          this.registerForm.setErrors({ serverMismatch: true });
        } else if (error.status === 409) {
          this.errorMessage = 'Email already exists. Please use a different email.';
        } else if (error.status === 400) {
          this.errorMessage = 'Invalid registration data. Please check your inputs.';
        } else {
          this.errorMessage = error.error?.message || error.message || 'Registration failed. Please try again.';
        }
      }
    });
  }
  showRequirements = false;

  checkPasswordRequirement(password: string | null | undefined, requirement: string): boolean {
    if (!password) return false;

    switch (requirement) {
      case 'length': return password.length >= 10;
      case 'uppercase': return /[A-Z]/.test(password);
      case 'lowercase': return /[a-z]/.test(password);
      case 'number': return /\d/.test(password);
      case 'special': return /[@$!%*?&]/.test(password);
      default: return false;
    }
  }

  togglePasswordVisibility(fieldId: string): void {
    const field = document.getElementById(fieldId) as HTMLInputElement;
    if (field) {
      field.type = field.type === 'password' ? 'text' : 'password';
      const icon = field.nextElementSibling?.querySelector('i.fa-eye-slash, i.fa-eye');
      if (icon) {
        icon.classList.toggle('fa-eye-slash');
        icon.classList.toggle('fa-eye');
      }
    }
  }

  onPasswordInput(): void {
    this.registerForm.get('password')?.updateValueAndValidity();
  }
  private closeModal(modalId: string): void {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.remove('show');
      modal.style.display = 'none';
      modal.setAttribute('aria-hidden', 'true');
      modal.removeAttribute('aria-modal');
      document.body.classList.remove('modal-open');

      const backdrop = document.querySelector('.modal-backdrop');
      if (backdrop) backdrop.remove();
    }
  }

  private openOtpModal(): void {
    const modal = document.getElementById('otpModal');
    if (modal) {
      modal.classList.add('show');
      modal.style.display = 'block';
      modal.setAttribute('aria-modal', 'true');
      modal.removeAttribute('aria-hidden');
      document.body.classList.add('modal-open');

      const backdrop = document.createElement('div');
      backdrop.classList.add('modal-backdrop', 'fade', 'show');
      document.body.appendChild(backdrop);
    }
  }


}