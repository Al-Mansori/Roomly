import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-booking',
  standalone: true,
  imports: [SideNavbarComponent, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './booking.component.html',
  styleUrl: './booking.component.scss'
})
export class BookingComponent {

}
