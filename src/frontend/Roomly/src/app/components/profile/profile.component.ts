import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";

@Component({
  selector: 'app-profile',
  standalone: true,
  imports: [SideNavbarComponent],
  templateUrl: './profile.component.html',
  styleUrl: './profile.component.scss'
})
export class ProfileComponent {

}
