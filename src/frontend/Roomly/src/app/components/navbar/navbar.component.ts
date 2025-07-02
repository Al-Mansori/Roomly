import { Component, ElementRef, ViewChild } from '@angular/core';

@Component({
  selector: 'app-navbar',
  standalone: true,
  imports: [],
  templateUrl: './navbar.component.html',
  styleUrl: './navbar.component.scss'
})
export class NavbarComponent {

  @ViewChild('navEl', { static: true }) navEl!: ElementRef;
  private height = 0;

  ngAfterViewInit(): void {
    this.height = this.navEl.nativeElement.offsetHeight;
  }

  getNavbarHeight(): number {
    return this.height;
  }

}
