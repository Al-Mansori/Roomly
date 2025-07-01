import { Component, signal } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";

@Component({
  selector: 'app-add-amenities',
  standalone: true,
  imports: [SideStepsIndicatorComponent],
  templateUrl: './add-amenities.component.html',
  styleUrl: './add-amenities.component.scss'
})
export class AddAmenitiesComponent {

    rooms = signal([
      {
        id: 1,
        name: 'Star Room',
        description: 'Spacious with natural light, ideal for collaboration.',
        image: './../assets/Images/room01.png',
        price: 30,
      },
      {
        id: 2,
        name: 'Private Office',
        description: 'Enclosed and quiet, best for focused work.',
        image: './../assets/Images/room02.png',
        price: 50
      }
    ]);
  
  steps = [
    { icon: 'Add Worksapce step indicator.png', label: 'Add Workspace', active: true },
    { icon: 'Add Rooms step indicator.png', label: 'Rooms', active: true },
    { icon: 'Add amenities step indicator.png', label: 'Amenities', active: true },
    { icon: 'Reception hours step indicator.png', label: 'Recipients', active: false }
  ];

}
