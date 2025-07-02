import { Component, ElementRef, Renderer2, ViewChild } from '@angular/core';
import { NavbarComponent } from "../../components/navbar/navbar.component";
import { RouterOutlet } from '@angular/router';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-blank-layout',
  standalone: true,
  imports: [NavbarComponent, RouterOutlet, CommonModule],
  templateUrl: './blank-layout.component.html',
  styleUrl: './blank-layout.component.scss'
})
export class BlankLayoutComponent {

  // @ViewChild('blankNavbar', { static: false, read: ElementRef }) navbarRef!: ElementRef;

  // navbarHeight = 0;

  // @ViewChild(NavbarComponent) navbarComponent!: NavbarComponent;
  // navbarHeight = 0;

  // ngAfterViewInit(): void {
  //   // Get height from the navbar component
  //   this.navbarHeight = this.navbarComponent.getNavbarHeight();
  // }

}
