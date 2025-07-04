import { CommonModule } from '@angular/common';
import { Component, Input } from '@angular/core';
import { RouterModule } from '@angular/router';

export interface Step {
  icon: string;
  label: string;
  active: boolean;
}
@Component({
  selector: 'app-side-steps-indicator',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './side-steps-indicator.component.html',
  styleUrl: './side-steps-indicator.component.scss'
})
export class SideStepsIndicatorComponent {
  // // @Input() steps: Step[] = [];
  //   @Input() steps: { icon: string; label: string; active: boolean }[] = [];
  display() : void{
    console.log("clicked")
  }


}
