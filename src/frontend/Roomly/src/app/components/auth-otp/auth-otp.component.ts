import { Component, OnDestroy, OnInit } from '@angular/core';
import { NavAuthComponent } from "../nav-auth/nav-auth.component";
import { HeroSectionComponent } from "../hero-section/hero-section.component";
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { AuthService } from '../../core/services/auth/auth.service';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthStateService } from '../../core/services/auth-state/auth-state.service';

@Component({
  selector: 'app-auth-otp',
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './auth-otp.component.html',
  styleUrl: './auth-otp.component.scss'
})
export class AuthOtpComponent implements OnInit, OnDestroy {
  otpForm: FormGroup;
  isVerifying = false;
  errorMessage = '';
  resendCountdown = 30;
  email = '';
  userId = '';
  private countdownInterval: any;
  private registrationData: any; // Add this property
  isPasswordReset = false;



  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router,
    private authState: AuthStateService,
  ) {
    this.otpForm = this.fb.group({
      digit1: ['', [Validators.required, Validators.pattern(/[0-9]/)]],
      digit2: ['', [Validators.required, Validators.pattern(/[0-9]/)]],
      digit3: ['', [Validators.required, Validators.pattern(/[0-9]/)]],
      digit4: ['', [Validators.required, Validators.pattern(/[0-9]/)]],
      digit5: ['', [Validators.required, Validators.pattern(/[0-9]/)]],
      digit6: ['', [Validators.required, Validators.pattern(/[0-9]/)]]
    });
  }

  ngOnInit(): void {
    this.authState.otpData$.subscribe(data => {
      if (data) {
        this.email = data.email;
        this.userId = data.userId ?? '';
        this.registrationData = data.registrationData;
        this.isPasswordReset = data.isPasswordReset ?? false;
        this.startResendCountdown();
      }
    });
  }

  ngOnDestroy(): void {
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval);
    }
  }

  moveToNext(index: number, event: Event): void {
    const input = event.target as HTMLInputElement;
    const value = input.value.replace(/[^0-9]/g, '');
    input.value = value; // Ensure only numbers

    // Auto-move to next field when a digit is entered
    if (value.length === 1 && index < 6) {
      const nextInput = document.querySelector(`[formControlName="digit${index + 1}"]`) as HTMLInputElement;
      if (nextInput) {
        nextInput.focus();
        nextInput.select(); // Optional: highlights the text in next field
      }
    }

    // Auto-submit when last digit is entered
    if (index === 6 && value.length === 1 && this.otpForm.valid) {
      this.verifyOtp();
    }
  }

  onKeyDown(index: number, event: KeyboardEvent): void {
    const input = event.target as HTMLInputElement;

    // Handle backspace
    if (event.key === 'Backspace' && input.value === '') {
      if (index > 1) {
        const prevInput = document.querySelector(`[formControlName="digit${index - 1}"]`) as HTMLInputElement;
        prevInput?.focus();
      }
      event.preventDefault();
    }
    // Allow only numeric input
    else if (!/[0-9]/.test(event.key) &&
      event.key !== 'Backspace' &&
      event.key !== 'Tab' &&
      event.key !== 'ArrowLeft' &&
      event.key !== 'ArrowRight') {
      event.preventDefault();
    }
  }

  onPaste(event: ClipboardEvent): void {
    event.preventDefault();
    const clipboardData = event.clipboardData?.getData('text/plain').trim();

    if (clipboardData && /^\d{6}$/.test(clipboardData)) {
      const digits = clipboardData.split('');
      this.otpForm.patchValue({
        digit1: digits[0],
        digit2: digits[1],
        digit3: digits[2],
        digit4: digits[3],
        digit5: digits[4],
        digit6: digits[5]
      });
      const lastInput = document.querySelector('[formControlName="digit6"]') as HTMLInputElement;
      lastInput?.focus();
    }
  }

  // Update verifyOtp method
  // verifyOtp(): void {
  //   if (this.otpForm.invalid) {
  //     this.otpForm.markAllAsTouched();
  //     return;
  //   }

  //   this.isVerifying = true;
  //   this.errorMessage = '';

  //   const otp = Object.values(this.otpForm.value).join('');

  //   if (this.isPasswordReset) {
  //     // Handle password reset OTP verification
  //     this.authService.verifyResetOtp({
  //       email: this.email,
  //       otp: otp
  //     }).subscribe({
  //       next: (response) => {
  //         this.isVerifying = false;
  //         if (response.status) {
  //           this.authState.clearOtpData();
  //           this.closeOtpModal();
  //           // Open password reset form in login modal
  //           setTimeout(() => this.openPasswordResetModal(), 500);
  //         } else {
  //           this.errorMessage = response.error || 'Invalid OTP';
  //         }
  //       },
  //       error: (error) => {
  //         this.isVerifying = false;
  //         this.errorMessage = error.error?.error || 'OTP verification failed';
  //       }
  //     });
  //   } else {
  //     // Existing registration OTP verification
  //     this.authService.verifyOtp(otp).subscribe({
  //       next: (response) => {
  //         this.isVerifying = false;
  //         if (response.registrationStatus) {
  //           this.authState.clearOtpData();
  //           this.closeOtpModal();
  //           this.showLoginModal();
  //         } else {
  //           this.errorMessage = response.error || 'Invalid or expired verification code';
  //         }
  //       },
  //       error: (error) => {
  //         this.isVerifying = false;
  //         this.errorMessage = error.error?.error || 'Verification failed. Please try again.';
  //       }
  //     });
  //   }
  // }

  verifyOtp(): void {
    if (this.otpForm.invalid) {
      this.otpForm.markAllAsTouched();
      return;
    }
    this.isVerifying = true;
    this.errorMessage = '';
    const otp = Object.values(this.otpForm.value).join('');
    if (this.isPasswordReset) {
      this.authService.verifyResetOtp({ email: this.email, otp }).subscribe({
        next: (response) => {
          this.handleOtpVerificationResponse(response);
        },
        error: (error) => {
          this.handleOtpError(error);
        }
      });
    } else {
      this.authService.verifyOtp(otp).subscribe({
        next: (response) => {
          this.handleOtpVerificationResponse(response);
        },
        error: (error) => {
          this.handleOtpError(error);
        }
      });
    }
  }
    private handleOtpVerificationResponse(response: any): void {
    this.isVerifying = false;
    if (response.status || response.registrationStatus) {
      this.authState.clearOtpData();
      this.closeOtpModal();
      if (this.isPasswordReset) {
        this.authState.setOtpData(this.email, undefined, undefined, true); // Keep email for reset
        setTimeout(() => this.openPasswordResetModal(), 500);
      } else {
        this.showLoginModal();
      }
    } else {
      this.errorMessage = response.error || 'Invalid or expired verification code';
    }
  }

  private handleOtpError(error: any): void {
    this.isVerifying = false;
    this.errorMessage = error.error?.error || (this.isPasswordReset ? 'OTP verification failed' : 'Verification failed. Please try again.');
  }
  // private openPasswordResetModal(): void {
  //   // You'll need to implement this to show the password reset form
  //   // This could be done by:
  //   // 1. Using a service to communicate with LoginComponent
  //   // 2. Directly manipulating the DOM (less ideal)
  //   // 3. Using a state management solution

  //   // Simple implementation (adjust based on your needs):
  //   const loginModal = document.getElementById('loginModal');
  //   if (loginModal) {
  //     loginModal.classList.add('show');
  //     loginModal.style.display = 'block';
  //     document.body.classList.add('modal-open');

  //     // Trigger the password reset view in LoginComponent
  //     // You might need to add a custom event or use a service
  //     const loginComponent = (window as any).loginComponent;
  //     if (loginComponent) {
  //       loginComponent.startPasswordReset(this.email);
  //     }
  //   }
  // }
  private openPasswordResetModal(): void {
    const loginModal = document.getElementById('loginModal');
    if (loginModal) {
      loginModal.classList.add('show');
      loginModal.style.display = 'block';
      document.body.classList.add('modal-open');
      const backdrop = document.createElement('div');
      backdrop.classList.add('modal-backdrop', 'fade', 'show');
      document.body.appendChild(backdrop);
    }
  }

  private showLoginModal(): void {
    const loginModal = document.getElementById('loginModal');
    if (loginModal) {
      loginModal.classList.add('show');
      loginModal.style.display = 'block';
      document.body.classList.add('modal-open');
    }
  }


  // resendOtp(): void {
  //   if (this.resendCountdown > 0 || !this.registrationData) return;

  //   this.authService.registerStaff(this.registrationData).subscribe({
  //     next: (response) => {
  //       if (response.registrationStatus) {
  //         this.resendCountdown = 30;
  //         this.startResendCountdown();
  //         this.errorMessage = '';
  //       } else {
  //         this.errorMessage = response.message || 'Failed to resend OTP';
  //       }
  //     },
  //     error: (error: any) => {
  //       this.errorMessage = error.error?.error || 'Failed to resend OTP. Please try again.';
  //     }
  //   });
  // }
  resendOtp(): void {
    if (this.resendCountdown > 0) return;
    this.errorMessage = '';
    if (this.isPasswordReset) {
      this.authService.forgotPassword(this.email).subscribe({
        next: (response) => {
          if (response.status) {
            this.resendCountdown = 30;
            this.startResendCountdown();
            this.errorMessage = 'OTP resent successfully';
          } else {
            this.errorMessage = response.error || 'Failed to resend OTP';
          }
        },
        error: () => {
          this.errorMessage = 'Failed to resend OTP. Please try again.';
        }
      });
    } else {
      if (!this.registrationData) return;
      this.authService.registerStaff(this.registrationData).subscribe({
        next: (response) => {
          if (response.registrationStatus) {
            this.resendCountdown = 30;
            this.startResendCountdown();
            this.errorMessage = '';
          } else {
            this.errorMessage = response.message || 'Failed to resend OTP';
          }
        },
        error: (error: any) => {
          this.errorMessage = error.error?.error || 'Failed to resend OTP. Please try again.';
        }
      });
    }
  }


  private startResendCountdown(): void {
    if (this.countdownInterval) {
      clearInterval(this.countdownInterval);
    }

    this.countdownInterval = setInterval(() => {
      this.resendCountdown--;
      if (this.resendCountdown <= 0) {
        clearInterval(this.countdownInterval);
      }
    }, 1000);
  }

  closeOtpModal(): void {
    const modal = document.getElementById('otpModal');
    if (modal) {
      modal.classList.remove('show');
      modal.style.display = 'none';
      document.body.classList.remove('modal-open');
    }
  }
}