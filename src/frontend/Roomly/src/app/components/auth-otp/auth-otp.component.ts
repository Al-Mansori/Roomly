import { Component } from '@angular/core';
import { NavAuthComponent } from "../nav-auth/nav-auth.component";
import { HeroSectionComponent } from "../hero-section/hero-section.component";

@Component({
  selector: 'app-auth-otp',
  standalone: true,
  imports: [NavAuthComponent, HeroSectionComponent],
  templateUrl: './auth-otp.component.html',
  styleUrl: './auth-otp.component.scss'
})
export class AuthOtpComponent {

}
