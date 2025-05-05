import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { NavAuthComponent } from './components/nav-auth/nav-auth.component';
import { HomeComponent } from './components/home/home.component';
import { HeroSectionComponent } from "./components/hero-section/hero-section.component";
import { AboutUsComponent } from "./components/about-us/about-us.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NavAuthComponent, HomeComponent, HeroSectionComponent, AboutUsComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'Roomly';
}
