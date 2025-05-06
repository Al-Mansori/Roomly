import { Component } from '@angular/core';
import { NavAuthComponent } from "../nav-auth/nav-auth.component";
import { HeroSectionComponent } from "../hero-section/hero-section.component";

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [NavAuthComponent, HeroSectionComponent],
  templateUrl: './register.component.html',
  styleUrl: './register.component.scss'
})
export class RegisterComponent {

}
