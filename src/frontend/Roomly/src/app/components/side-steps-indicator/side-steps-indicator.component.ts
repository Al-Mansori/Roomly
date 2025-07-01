import { CommonModule } from '@angular/common';
import { Component, Input } from '@angular/core';

export interface Step {
  icon: string;
  label: string;
  active: boolean;
}
@Component({
  selector: 'app-side-steps-indicator',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './side-steps-indicator.component.html',
  styleUrl: './side-steps-indicator.component.scss'
})
export class SideStepsIndicatorComponent {
  // @Input() steps: Step[] = [];
    @Input() steps: { icon: string; label: string; active: boolean }[] = [];


}
