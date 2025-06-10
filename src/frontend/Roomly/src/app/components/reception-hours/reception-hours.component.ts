import { Component } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";
import { FormsModule } from '@angular/forms';


@Component({
  selector: 'app-reception-hours',
  standalone: true,
  imports: [SideStepsIndicatorComponent, FormsModule],
  templateUrl: './reception-hours.component.html',
  styleUrl: './reception-hours.component.scss'
})
export class ReceptionHoursComponent {
    steps = [
    { icon: 'Add Worksapce step indicator.png', label: 'Add Workspace', active: true },
    { icon: 'Add Rooms step indicator.png', label: 'Rooms', active: true },
    { icon: 'Add amenities step indicator.png', label: 'Amenities', active: true },
    { icon: 'Reception hours step indicator.png', label: 'Recipients', active: true }
  ];

  days = () => [
  { id: 0, label: 'all days', startTime: '00:00', endTime: '12:00' },
  { id: 1, label: 'saturday', startTime: '00:00', endTime: '12:00' },
  { id: 2, label: 'sunday', startTime: '00:00', endTime: '12:00' },
  { id: 3, label: 'monday', startTime: '00:00', endTime: '12:00' },
  { id: 4, label: 'tuesday', startTime: '00:00', endTime: '12:00' },
  { id: 5, label: 'wednesday', startTime: '00:00', endTime: '12:00' },
  { id: 6, label: 'thursday', startTime: '00:00', endTime: '12:00' },
  { id: 7, label: 'friday', startTime: '00:00', endTime: '12:00' },
];


}
