import { Component, inject } from '@angular/core';
import { NavAuthComponent } from "../../components/nav-auth/nav-auth.component";
import { RouterOutlet } from '@angular/router';
import { RegisterComponent } from "../../components/register/register.component";
import { LoginComponent } from "../../components/login/login.component";
import { AuthOtpComponent } from "../../components/auth-otp/auth-otp.component";
import { AuthService } from '../../core/services/auth/auth.service';

@Component({
  selector: 'app-auth-layout',
  standalone: true,
  imports: [NavAuthComponent, RouterOutlet, RegisterComponent, LoginComponent, AuthOtpComponent],
  templateUrl: './auth-layout.component.html',
  styleUrl: './auth-layout.component.scss'
})
export class AuthLayoutComponent {
    private readonly authService = inject(AuthService); // Use inject() or constructor


}
