import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";

@Component({
  selector: 'app-change-password',
  standalone: true,
  imports: [SideNavbarComponent],
  templateUrl: './change-password.component.html',
  styleUrl: './change-password.component.scss'
})
export class ChangePasswordComponent {

}
