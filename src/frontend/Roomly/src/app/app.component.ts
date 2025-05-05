import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { NavAuthComponent } from './components/nav-auth/nav-auth.component';
import { HomeComponent } from './components/home/home.component';
import { HeroSectionComponent } from "./components/hero-section/hero-section.component";
import {ContactUsComponent } from "./components/contact-us/contact-us.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NavAuthComponent, HomeComponent, HeroSectionComponent, ContactUsComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'Roomly';
}
