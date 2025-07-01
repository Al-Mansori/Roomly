import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';

interface MenuItem {
  id: string;
  label: string;
  link: string;
  active: boolean;
}

@Component({
  selector: 'app-side-navbar',
  standalone: true,
  imports: [RouterLink, RouterLinkActive],
  templateUrl: './side-navbar.component.html',
  styleUrl: './side-navbar.component.scss'
})
export class SideNavbarComponent {

  isOpen = true;
  
  menuItems: MenuItem[] = [
    { id: 'dashboard', label: 'Dashboard', link: '/dashboard', active: false },
    { id: 'workspaces', label: 'My Workspaces', link: '/workspaces', active: false },
    { id: 'booking', label: 'Booking', link: '/booking', active: true },
    { id: 'userlist', label: 'User list', link: '/users', active: false }
  ];

  toggleSidebar() {
    this.isOpen = !this.isOpen;
  }

  logout() {
    // Implement logout functionality
    console.log('Logout clicked');
  }
}
