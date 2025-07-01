import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

interface OtpData {
  email: string;
  userId?: string;
  isPasswordReset?: boolean;
  registrationData?: {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    confirmPassword: string;
    phone: string;
    staff: boolean;
  };
}

@Injectable({ providedIn: 'root' })
export class AuthStateService {

  private otpDataSubject = new BehaviorSubject<OtpData | null>(null);
  otpData$ = this.otpDataSubject.asObservable();

  getCurrentOtpData(): OtpData | null {
    return this.otpDataSubject.value;
  }

  // setOtpData(email: string, userId: string, registrationData?: OtpData['registrationData']): void {
  //   this.otpDataSubject.next({ email, userId, registrationData });
  // }
    setOtpData(
    email: string, 
    userId?: string, // Made optional
    registrationData?: OtpData['registrationData'],
    isPasswordReset?: boolean
  ): void {
    this.otpDataSubject.next({ email, userId, registrationData, isPasswordReset });
  }


  clearOtpData(): void {
    this.otpDataSubject.next(null);
  }
}