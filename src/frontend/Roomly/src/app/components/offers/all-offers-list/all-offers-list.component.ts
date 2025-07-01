import { Component } from '@angular/core';
import { SideNavbarComponent } from "../../side-navbar/side-navbar.component";
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';

@Component({
  selector: 'app-all-offers-list',
  standalone: true,
  imports: [SideNavbarComponent, FormsModule, CommonModule, RouterLink, RouterLinkActive, RouterOutlet],
  templateUrl: './all-offers-list.component.html',
  styleUrl: './all-offers-list.component.scss'
})
export class AllOffersListComponent {

  offers = () => [
    {
      id: '1',
      title: 'Weekend Special Offer',
      dateFrom: 'Friday, 28 May 2024',
      dateTo: 'Sunday, 30 May 2024',
      startTime: '08:00 AM',
      endTime: '11:59 PM',
      status: 'present',
    },
    {
      id: '2',
      title: 'Holiday Discount',
      dateFrom: 'Monday, 15 Apr 2024',
      dateTo: 'Wednesday, 17 Apr 2024',
      startTime: '09:00 AM',
      endTime: '10:00 PM',
      status: 'expired',
    },
    {
      id: '3',
      title: 'Holiday Discount',
      dateFrom: 'Monday, 15 Apr 2024',
      dateTo: 'Wednesday, 17 Apr 2024',
      startTime: '09:00 AM',
      endTime: '10:00 PM',
      status: 'expired',
    },
    {
      id: '4',
      title: 'Holiday Discount',
      dateFrom: 'Monday, 15 Apr 2024',
      dateTo: 'Wednesday, 17 Apr 2024',
      startTime: '09:00 AM',
      endTime: '10:00 PM',
      status: 'present',
    }
  ];


}
