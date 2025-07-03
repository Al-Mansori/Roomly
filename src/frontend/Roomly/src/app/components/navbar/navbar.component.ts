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

<<<<<<< HEAD
  isMenuOpen = false;

  toggleMenu() {
    this.isMenuOpen = !this.isMenuOpen;
  }

  logout() {
    localStorage.removeItem('token');
    this.router.navigate(['/login']);
  }
=======
  @ViewChild('navEl', { static: true }) navEl!: ElementRef;
  private height = 0;

  ngAfterViewInit(): void {
    this.height = this.navEl.nativeElement.offsetHeight;
  }

  getNavbarHeight(): number {
    return this.height;
  }

>>>>>>> 9d890f7d568efeec9b3f76b0f6af0208c8729ee7
}
