import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { AllBookingsComponent } from "../all-bookings/all-bookings.component";
import { RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-booking',
  standalone: true,
  imports: [SideNavbarComponent, AllBookingsComponent, RouterOutlet],
  templateUrl: './booking.component.html',
  styleUrl: './booking.component.scss'
})
export class BookingComponent {

}
