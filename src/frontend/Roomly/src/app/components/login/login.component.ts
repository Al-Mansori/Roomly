import { Component, inject } from '@angular/core';
import { NavAuthComponent } from "../nav-auth/nav-auth.component";
import { FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { AuthService } from '../../core/services/auth/auth.service';
import { CommonModule } from '@angular/common';
import { Route, Router } from '@angular/router';
import { AuthStateService } from '../../core/services/auth-state/auth-state.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [ReactiveFormsModule, CommonModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent {
  loginForm: FormGroup;
  errorMessage = '';
  isLoading = false;
  showForgotPassword = false;
  forgotPasswordEmail = '';
  forgotPasswordLoading = false;
  isResettingPassword = false;
  resetPasswordEmail = '';
  newPassword = '';
  confirmPassword = '';
  passwordStrength: { [key: string]: boolean } = {};
  isEmailValid = false;

  passwordRequirements = [
    { text: 'At least 10 characters', key: 'length' },
    { text: 'At least one uppercase letter', key: 'uppercase' },
    { text: 'At least one lowercase letter', key: 'lowercase' },
    { text: 'At least one number', key: 'number' },
    { text: 'At least one special character (@$!%*?&)', key: 'special' }
  ];

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router,
    private authState: AuthStateService
  ) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required]],
      rememberMe: [false]
    });

    // Subscribe to OTP data to handle reset password view
    this.authState.otpData$.subscribe(data => {
      if (data?.isPasswordReset && !this.isResettingPassword) {
        this.isResettingPassword = true;
        this.resetPasswordEmail = data.email;
        this.showForgotPassword = false;
        this.openLoginModal();
      }
    });
  }

  checkPasswordStrength(password: string): { [key: string]: boolean } {
    return {
      length: password.length >= 10,
      uppercase: /[A-Z]/.test(password),
      lowercase: /[a-z]/.test(password),
      number: /\d/.test(password),
      special: /[@$!%*?&]/.test(password)
    };
  }

  passwordMeetsRequirements(): boolean {
    if (!this.newPassword) return false;
    const strength = this.checkPasswordStrength(this.newPassword);
    return Object.values(strength).every(valid => valid);
  }

  updatePasswordStrength(): void {
    this.passwordStrength = this.checkPasswordStrength(this.newPassword);
  }

  validateEmail(): void {
    this.errorMessage = '';
    this.isEmailValid = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(this.forgotPasswordEmail);
    if (this.forgotPasswordEmail && !this.isEmailValid) {
      this.errorMessage = 'Please enter a valid email address.';
    }
  }

  onLogin(): void {
    if (this.loginForm.invalid) {
      this.loginForm.markAllAsTouched();
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';

    const { email, password, rememberMe } = this.loginForm.value;

    this.authService.login({ email, password, isStaff: true }).subscribe({
      next: (res) => {
        this.isLoading = false;

        if (res.error) {
          this.errorMessage = res.error;
          return;
        }

        if (res.token && res.user) {
          this.handleLoginSuccess(res.token, res.user, rememberMe);
        }
      },
      error: () => {
        this.isLoading = false;
        this.errorMessage = 'Login failed. Please try again.';
      }
    });
  }

  private handleLoginSuccess(token: string, user: any, rememberMe: boolean): void {
    if (rememberMe) {
      localStorage.setItem('token', token);
      localStorage.setItem('user', JSON.stringify(user));
    } else {
      sessionStorage.setItem('token', token);
      sessionStorage.setItem('user', JSON.stringify(user));
    }

    this.closeLoginModal();
    this.router.navigate(['/dashboard']);
  }

  onForgotPassword(): void {
    this.showForgotPassword = true;
    const emailControl = this.loginForm.get('email');
    this.forgotPasswordEmail = emailControl?.value || '';
    this.validateEmail();
    this.errorMessage = '';
  }

  submitForgotPassword(): void {
    if (!this.forgotPasswordEmail || !this.isEmailValid) {
      this.errorMessage = 'Please enter a valid email address.';
      return;
    }
    this.forgotPasswordLoading = true;
    this.errorMessage = '';
    this.authService.forgotPassword(this.forgotPasswordEmail).subscribe({
      next: (res) => {
        this.forgotPasswordLoading = false;
        if (res.status) {
          this.handleForgotPasswordSuccess();
        } else {
          this.errorMessage = res.error || 'Failed to send OTP';
        }
      },
      error: () => {
        this.forgotPasswordLoading = false;
        this.errorMessage = 'Failed to send OTP. Please try again.';
      }
    });
  }

  startPasswordReset(email: string): void {
    this.isResettingPassword = true;
    this.resetPasswordEmail = email;
    this.errorMessage = '';
    this.openLoginModal();
  }

  submitNewPassword(): void {
    if (this.newPassword !== this.confirmPassword) {
      this.errorMessage = 'Passwords do not match';
      return;
    }
    if (!this.passwordMeetsRequirements()) {
      this.errorMessage = 'Password does not meet requirements';
      return;
    }

    this.isLoading = true;
    this.errorMessage = '';
    this.authService.resetPassword({
      email: this.resetPasswordEmail, // Fixed: Use resetPasswordEmail
      newPassword: this.newPassword
    }).subscribe({
      next: (response) => {
        this.isLoading = false;
        if (response.status) {
          this.handlePasswordResetSuccess();
        } else {
          this.errorMessage = response.error || 'Password reset failed';
        }
      },
      error: () => {
        this.isLoading = false;
        this.errorMessage = 'Password reset failed. Please try again.';
      }
    });
  }

  private handleForgotPasswordSuccess(): void {
    this.authState.setOtpData(
      this.forgotPasswordEmail,
      undefined,
      undefined,
      true
    );

    this.closeLoginModal();
    setTimeout(() => this.openOtpModal(), 500);
  }

  private handlePasswordResetSuccess(): void {
    this.isResettingPassword = false;
    this.showForgotPassword = false;
    this.errorMessage = '';
    this.newPassword = '';
    this.confirmPassword = '';
    this.authState.clearOtpData(); // Added: Clear state for consistency
    setTimeout(() => this.openLoginModal(), 500);
  }

  private closeLoginModal(): void {
    const modal = document.getElementById('loginModal');
    if (modal) {
      modal.classList.remove('show');
      modal.style.display = 'none';
      document.body.classList.remove('modal-open');
      const backdrop = document.querySelector('.modal-backdrop');
      if (backdrop) backdrop.remove();
    }
  }

  private openLoginModal(): void {
    const modal = document.getElementById('loginModal');
    if (modal) {
      modal.classList.add('show');
      modal.style.display = 'block';
      document.body.classList.add('modal-open');
      const backdrop = document.createElement('div');
      backdrop.classList.add('modal-backdrop', 'fade', 'show');
      document.body.appendChild(backdrop);
    }
  }

  private openOtpModal(): void {
    const modal = document.getElementById('otpModal');
    if (modal) {
      modal.classList.add('show');
      modal.style.display = 'block';
      document.body.classList.add('modal-open');
      const backdrop = document.createElement('div');
      backdrop.classList.add('modal-backdrop', 'fade', 'show');
      document.body.appendChild(backdrop);
    }
  }


  cancelResetPassword(): void {
    this.isResettingPassword = false;
    this.newPassword = '';
    this.confirmPassword = '';
    this.errorMessage = '';
    this.authState.clearOtpData();
    this.openLoginModal();
  }
}