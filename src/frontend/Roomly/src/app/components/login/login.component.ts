import { Component } from '@angular/core';
import { NavAuthComponent } from "../nav-auth/nav-auth.component";
import { HeroSectionComponent } from "../hero-section/hero-section.component";

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [NavAuthComponent, HeroSectionComponent],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss'
})
export class LoginComponent {

}
