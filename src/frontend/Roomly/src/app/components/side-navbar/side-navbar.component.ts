import { Component } from '@angular/core';
import { Router, RouterLink, RouterLinkActive, RouterModule, RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-side-navbar',
  standalone: true,
  imports: [
    CommonModule,
    RouterLink,
    RouterLinkActive,
    RouterModule,
  ],
  templateUrl: './side-navbar.component.html',
  styleUrl: './side-navbar.component.scss'
})
export class SideNavbarComponent {
  constructor(public router: Router) { }
  isOpen = true;

  toggleSidebar() {
    this.isOpen = !this.isOpen;
  }

  // isActive(route: string): boolean {
  //   return this.router.url.startsWith(route);
  // }
  isActive(route: string): boolean {
    return this.router.url === route ||
      (route !== '/' && this.router.url.startsWith(route));
  }

  logout() {
    console.log('Logout clicked');
  }
}
