import { isPlatformBrowser } from '@angular/common';
import { AfterViewInit, Component, ElementRef, Inject, PLATFORM_ID, Renderer2 } from '@angular/core';

@Component({
  selector: 'app-hero-section',
  standalone: true,
  imports: [],
  templateUrl: './hero-section.component.html',
  styleUrl: './hero-section.component.scss'
})
export class HeroSectionComponent {

  // constructor(private renderer: Renderer2, private el: ElementRef) { }

  // ngAfterViewInit(): void {
  //   const navbar = document.getElementById('navAuth');
  //   if (navbar) {
  //     const height = navbar.offsetHeight;
  //     this.renderer.setStyle(this.el.nativeElement, 'padding-top', `${height}px`);
  //   }
  // }
  // constructor(@Inject(PLATFORM_ID) private platformId: Object) {}

  // ngAfterViewInit(): void {
  //   if (isPlatformBrowser(this.platformId)) {
  //     // ✅ Safe to access document here
  //     const hero = document.getElementById('hero-section');
  //     if (hero) {
  //       // Do something with hero section
  //       console.log('Hero section found:', hero);
  //     }
  //   }
  // }



}
