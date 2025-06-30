import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { catchError, Observable, of, throwError } from 'rxjs';
import { environment } from '../../environment/environments';

interface RegisterResponse {
  registrationStatus: boolean;
  userId: string;
  message?: string;
}

interface VerifyOtpResponse {
  registrationStatus: boolean;
  error?: string;
}

interface LoginResponse {
  user?: any;
  token?: string;
  error?: string;
}
interface ForgotPasswordResponse {
  status: boolean;
  message?: string;
  error?: string;
}

interface VerifyResetOtpResponse {
  status: boolean;
  message?: string;
  error?: string;
}

interface ResetPasswordResponse {
  status: boolean;
  message?: string;
  error?: string;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private readonly http = inject(HttpClient);

  registerStaff(data: {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    confirmPassword: string;
    phone: string;
    staff: boolean;
  }): Observable<RegisterResponse> {
    return this.http.post<RegisterResponse>(
      `/api/users/auth/register-staff`,
      data
    );
  }

  verifyOtp(otp: string): Observable<VerifyOtpResponse> {
    return this.http.post<VerifyOtpResponse>(
      `/api/users/auth/verify?otp=${otp}`, // OTP in query
      null // No body!
    ).pipe(
      catchError(error => {
        if (error.error?.error) {
          return of({ registrationStatus: false, error: error.error.error });
        }
        return throwError(() => error);
      })
    );
  }



  // login(email: string, password: string, isStaff: boolean): Observable<{ user: any; token: string; error?: string }> {
  //   return this.http.post<{ user: any; token: string; error?: string }>(
  //     `/api/users/auth/login`,
  //     { email, password, isStaff }
  //   ).pipe(
  //     catchError(error => {
  //       const err = error.error?.error || 'Login failed. Please try again.';
  //       return of({ user: null, token: '', error: err });
  //     })
  //   );
  // }


  // forgetPassword(email: string): Observable<ResetPasswordResponse> {
  //   return this.http.post<ResetPasswordResponse>(
  //     `/api/users/auth/forgot-password`,
  //     { email }  // only email required to resend
  //   ).pipe(
  //     catchError(error => {
  //       if (error.error?.error) {
  //         return of({ status: false, error: error.error.error });
  //       }
  //       return throwError(() => error);
  //     })
  //   );
  // }
  login(data: { email: string; password: string; isStaff: boolean }): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(
      '/api/users/auth/login',
      data
    ).pipe(
      catchError(error => of({
        error: error.error?.error || 'Login failed'
      }))
    );
  }

  forgotPassword(email: string): Observable<ForgotPasswordResponse> {
    return this.http.post<ForgotPasswordResponse>(
      '/api/users/auth/forgot-password',
      { email }
    ).pipe(
      catchError(error => of({
        status: false,
        error: error.error?.error || 'Failed to send OTP'
      }))
    );
  }

  verifyResetOtp(data: { email: string; otp: string }): Observable<VerifyResetOtpResponse> {
    return this.http.post<VerifyResetOtpResponse>(
      '/api/users/auth/verify-reset-otp',
      data
    ).pipe(
      catchError(error => of({
        status: false,
        error: error.error?.error || 'OTP verification failed'
      }))
    );
  }

  resetPassword(data: { email: string; newPassword: string }): Observable<ResetPasswordResponse> {
    return this.http.post<ResetPasswordResponse>(
      '/api/users/auth/reset-password',
      data
    ).pipe(
      catchError(error => of({
        status: false,
        error: error.error?.error || 'Password reset failed'
      }))
    );
  }


}