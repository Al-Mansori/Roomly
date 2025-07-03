import { Router, RouterModule } from '@angular/router'; 
import { Component, ElementRef, ViewChild } from '@angular/core';

@Component({
  selector: 'app-navbar',
  standalone: true,
  templateUrl: './navbar.component.html',
  styleUrls: ['./navbar.component.scss'],
  imports: [RouterModule] 
})
export class NavbarComponent {
  constructor(private router: Router) {}

  isMenuOpen = false;

  toggleMenu() {
    this.isMenuOpen = !this.isMenuOpen;
  }

  logout() {
    localStorage.removeItem('token');
    this.router.navigate(['/login']);
  }
  @ViewChild('navEl', { static: true }) navEl!: ElementRef;
  private height = 0;

  ngAfterViewInit(): void {
    this.height = this.navEl.nativeElement.offsetHeight;
  }

  getNavbarHeight(): number {
    return this.height;
  }

}
