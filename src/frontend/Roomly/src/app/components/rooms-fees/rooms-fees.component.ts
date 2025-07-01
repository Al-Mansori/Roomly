import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";

@Component({
  selector: 'app-rooms-fees',
  standalone: true,
  imports: [SideNavbarComponent],
  templateUrl: './rooms-fees.component.html',
  styleUrl: './rooms-fees.component.scss'
})
export class RoomsFeesComponent {
  rooms = [
    {
      id: '20304',
      name: 'Room 01',
      image: 'assets/Images/room01.png',
      type: 'Office Room',
      price: '50$/hour',
      completionRate: '90%',
      cancellationRate: '10%',
      recommendedFee: '30EGP',
    },
    {
      id: '20304',
      name: 'Room 02',
      image: 'assets/Images/room02.png',
      type: 'Office Room',
      price: '50$/hour',
      completionRate: '90%',
      cancellationRate: '10%',
      recommendedFee: '30EGP',
    },
    {
      id: '20304',
      name: 'Room 03',
      image: 'assets/Images/room03.jpg',
      type: 'Office Room',
      price: '50$/hour',
      completionRate: '90%',
      cancellationRate: '10%',
      recommendedFee: '30EGP',
    },
    {
      id: '20304',
      name: 'Room 04',
      image: 'assets/Images/room03.jpg',
      type: 'Office Room',
      price: '50$/hour',
      completionRate: '90%',
      cancellationRate: '10%',
      recommendedFee: '30EGP',
    },
    {
      id: '20304',
      name: 'Room 05',
      image: 'assets/Images/room03.jpg',
      type: 'Office Room',
      price: '50$/hour',
      completionRate: '90%',
      cancellationRate: '10%',
      recommendedFee: '30EGP',
    }
  ];

}
