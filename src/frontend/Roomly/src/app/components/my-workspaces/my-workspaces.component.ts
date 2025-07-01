import { Component, signal } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { SwiperOptions } from 'swiper';



interface Room {
  id: number;
  name: string;
  image: string;
}

interface Workspace {
  id: number;
  name: string;
  location: string;
  createdAt: string;
  rating: number;
  reviews: number;
  image: string;
  rooms: Room[];
}

@Component({
  selector: 'app-my-workspaces',
  standalone: true,
  imports: [SideNavbarComponent],
  templateUrl: './my-workspaces.component.html',
  styleUrl: './my-workspaces.component.scss'
})
export class MyWorkspacesComponent {
   // Swiper configuration
   swiperConfig: SwiperOptions = {
    slidesPerView: 2,
    spaceBetween: 15,
    navigation: true,
    breakpoints: {
      0: { slidesPerView: 1 },
      576: { slidesPerView: 1 },
      768: { slidesPerView: 2 },
      992: { slidesPerView: 2 }
    }
  };

  workspaces = signal<Workspace[]>([
    {
      id: 1,
      name: 'Co-Working',
      location: 'Road 9-Maadi-Cairo',
      createdAt: '2020-02-20',
      rating: 4.92,
      reviews: 116,
      image: './assets/Images/my workspaces01.png',
      rooms: [
        { id: 101, name: 'Room 01', image: './assets/Images/room01.png' },
        { id: 102, name: 'Room 02', image: './assets/Images/room02.png' }
      ]
    },
    {
      id: 2,
      name: 'Open Office',
      location: 'New Cairo - 90th Street',
      createdAt: '2021-05-10',
      rating: 4.75,
      reviews: 89,
      image: './assets/Images/my workspaces02.png',
      rooms: [
        { id: 201, name: 'Office A', image: './assets/Images/room01.png' },
        { id: 202, name: 'Office B', image: './assets/Images/room01.png' }
      ]
    }
  ]);

  selectedWorkspace = signal<Workspace>(this.workspaces()[0]);

  selectWorkspace(workspace: Workspace): void {
    this.selectedWorkspace.set(workspace);
  }
}
