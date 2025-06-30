import { Component } from '@angular/core';
import { SideNavbarComponent } from "../../side-navbar/side-navbar.component";
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-bookings-list',
  standalone: true,
  imports: [SideNavbarComponent, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './bookings-list.component.html',
  styleUrl: './bookings-list.component.scss'
})
export class BookingsListComponent {

}
