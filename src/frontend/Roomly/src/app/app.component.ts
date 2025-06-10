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
import { BookingComponent } from "./components/booking/booking.component";
import { ProfileComponent } from "./components/profile/profile.component";
import { ChangePasswordComponent } from "./components/change-password/change-password.component";
import { UsersListComponent } from "./components/users-list/users-list.component";
import { MyWorkspacesComponent } from "./components/my-workspaces/my-workspaces.component";
import { AddOfferComponent } from "./components/add-offer/add-offer.component";
import { DashboardComponent } from "./components/dashboard/dashboard.component";
import { NavbarComponent } from "./components/navbar/navbar.component";
import { AddWorkspaceComponent } from "./components/add-workspace/add-workspace.component";
import { AddRoomsComponent } from "./components/add-rooms/add-rooms.component";
import { AddAmenitiesComponent } from "./components/add-amenities/add-amenities.component";
import { ReceptionHoursComponent } from "./components/reception-hours/reception-hours.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NavAuthComponent, HomeComponent,
    HeroSectionComponent, ContactUsComponent, AboutUsComponent,
    FooterComponent, SideNavbarComponent, RegisterComponent, LoginComponent, AuthOtpComponent, BookingComponent, ProfileComponent, ChangePasswordComponent, UsersListComponent, MyWorkspacesComponent, AddOfferComponent, DashboardComponent, NavbarComponent, AddWorkspaceComponent, AddRoomsComponent, AddAmenitiesComponent, ReceptionHoursComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'Roomly';
}
