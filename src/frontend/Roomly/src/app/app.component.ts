import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { NavAuthComponent } from './components/nav-auth/nav-auth.component';
import { HomeComponent } from './components/home/home.component';
import { HeroSectionComponent } from "./components/hero-section/hero-section.component";
import {ContactUsComponent } from "./components/contact-us/contact-us.component";
import {AboutUsComponent } from "./components/about-us/about-us.component";
import { FooterComponent } from "./components/footer/footer.component";
import { SideNavbarComponent } from "./components/side-navbar/side-navbar.component";
import { RegisterComponent } from "./components/register/register.component";
import { LoginComponent } from "./components/login/login.component";
import { AuthOtpComponent } from "./components/auth-otp/auth-otp.component";
import { BookingAllComponent } from "./components/booking-all/booking-all.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NavAuthComponent, HomeComponent,
    HeroSectionComponent, ContactUsComponent, AboutUsComponent,
    FooterComponent, SideNavbarComponent, RegisterComponent, LoginComponent, AuthOtpComponent, BookingAllComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'Roomly';
}
