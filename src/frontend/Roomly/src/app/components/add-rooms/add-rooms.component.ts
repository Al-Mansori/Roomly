import { Component, signal } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";

@Component({
  selector: 'app-add-rooms',
  standalone: true,
  imports: [SideStepsIndicatorComponent],
  templateUrl: './add-rooms.component.html',
  styleUrl: './add-rooms.component.scss'
})
export class AddRoomsComponent {
  steps = [
    { icon: 'Add Worksapce step indicator.png', label: 'Add Workspace', active: true },
    { icon: 'Add Rooms step indicator.png', label: 'Rooms', active: true },
    { icon: 'Add amenities step indicator.png', label: 'Amenities', active: false },
    { icon: 'Reception hours step indicator.png', label: 'Recipients', active: false }
  ];

  rooms = signal([
    {
      id: 1,
      name: 'Star Room',
      description: 'Spacious with natural light, ideal for collaboration.',
      image: './../assets/Images/room01.png',
    },
    {
      id: 2,
      name: 'Private Office',
      description: 'Enclosed and quiet, best for focused work.',
      image: './../assets/Images/room02.png',
    }
  ]);

  // Optional: Method to add a new room
  addRoom() {
    const newRoom = {
      id: Date.now(),
      name: 'New Room',
      description: 'Describe your new room here.',
      image: 'assets/Images/default.jpg'
    };
    this.rooms.update((list) => [...list, newRoom]);
  }

}
