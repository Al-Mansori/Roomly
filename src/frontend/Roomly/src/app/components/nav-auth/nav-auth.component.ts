import { AfterViewInit, Component, ElementRef } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';

@Component({
  selector: 'app-nav-auth',
  standalone: true,
  imports: [RouterLink, RouterLinkActive],
  templateUrl: './nav-auth.component.html',
  styleUrl: './nav-auth.component.scss'
})
export class NavAuthComponent{

  // constructor(private el: ElementRef) {}

  // ngAfterViewInit() {
  //   // Set CSS variable with navbar height
  //   const height = this.el.nativeElement.offsetHeight;
  //   document.documentElement.style.setProperty('--navbar-height', `${height}px`);
  // }
}
