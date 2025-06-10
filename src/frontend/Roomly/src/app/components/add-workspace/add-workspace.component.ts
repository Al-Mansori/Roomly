import { Component } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";

@Component({
  selector: 'app-add-workspace',
  standalone: true,
  imports: [SideStepsIndicatorComponent],
  templateUrl: './add-workspace.component.html',
  styleUrl: './add-workspace.component.scss'
})
export class AddWorkspaceComponent {

    steps = [
  { icon: 'Add Worksapce step indicator.png', label: 'Add Workspace', active: true },
  { icon: 'Add Rooms step indicator.png', label: 'Rooms', active: false },
  { icon: 'Add amenities step indicator.png', label: 'Amenities', active: false },
  { icon: 'Reception hours step indicator.png', label: 'Recipients', active: false }
];
}
