import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';

interface Booking {
  id: string;
  room: string;
  branch: string;
  image: string;
  startDate: Date;
  endDate: Date;
  seats: number;
  paymentMethod: string;
  price: number;
  status: 'upcoming' | 'ongoing' | 'completed';
  timeRemaining: string;
}

@Component({
  selector: 'app-all-bookings',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './all-bookings.component.html',
  styleUrl: './all-bookings.component.scss'
})
export class AllBookingsComponent {
  // activeTab = 'all';
  // indicatorPosition = 0;
  //   tabs = [
  //   { id: 'all', label: 'All' },
  //   { id: 'requests', label: 'Requests' },
  //   { id: 'upcoming', label: 'Upcoming' },
  //   { id: 'ongoing', label: 'Ongoing' },
  //   { id: 'history', label: 'History' }
  // ];



  // bookings: Booking[] = [
  //   {
  //     id: '153324',
  //     room: 'Meeting room A2',
  //     branch: 'Maadi branch 1',
  //     image: 'https://via.placeholder.com/300x200?text=Meeting+A2',
  //     startDate: new Date('2025-02-12T09:30:00'),
  //     endDate: new Date('2025-02-12T10:00:00'),
  //     seats: 5,
  //     paymentMethod: 'Cash',
  //     price: 200,
  //     status: 'upcoming',
  //     timeRemaining: '00:24:45'
  //   },
  //   {
  //     id: '153345',
  //     room: 'Desk D12',
  //     branch: 'Maadi branch 1',
  //     image: 'https://via.placeholder.com/300x200?text=Desk+D12',
  //     startDate: new Date('2025-02-12T09:30:00'),
  //     endDate: new Date('2025-02-12T10:00:00'),
  //     seats: 1,
  //     paymentMethod: 'Card',
  //     price: 600,
  //     status: 'ongoing',
  //     timeRemaining: '01:34:05'
  //   },
  //   {
  //     id: '153366',
  //     room: 'Meeting room A3',
  //     branch: 'Maadi branch 1',
  //     image: 'https://via.placeholder.com/300x200?text=Meeting+A3',
  //     startDate: new Date('2025-02-12T09:30:00'),
  //     endDate: new Date('2025-02-12T10:00:00'),
  //     seats: 2,
  //     paymentMethod: 'Cash',
  //     price: 200,
  //     status: 'upcoming',
  //     timeRemaining: '00:24:45'
  //   }
  // ];

  // get filteredBookings(): Booking[] {
  //   if (this.activeTab === 'all') return this.bookings;
  //   return this.bookings.filter(b => b.status === this.activeTab);
  // }

  // setActiveTab(tabId: string): void {
  //   this.activeTab = tabId;
  //   const index = this.tabs.findIndex(t => t.id === tabId);
  //   this.indicatorPosition = index * 100; // Adjust based on your design
  // }
      now = new Date();

    reservations =
    [
      {
        "id": "res001",
        "reservationDate": "2023-01-05T00:00:00.000+00:00",
        "startTime": "2023-01-10T09:00:00.000+00:00",
        "endTime": "2023-01-10T13:00:00.000+00:00",
        "status": "COMPLETED",
        "amenitiesCount": 3,
        "totalCost": 800.0,
        "payment": null,
        "accessCode": "ABC123"
      },
      {
        "id": "res002",
        "reservationDate": "2023-01-12T00:00:00.000+00:00",
        "startTime": "2023-01-15T14:00:00.000+00:00",
        "endTime": "2023-01-15T18:00:00.000+00:00",
        "status": "COMPLETED",
        "amenitiesCount": 2,
        "totalCost": 600.0,
        "payment": null,
        "accessCode": "ABC234"
      },
      {
        "id": "res003",
        "reservationDate": "2025-06-29T00:00:00.000+00:00",
        "startTime": "2025-06-29T10:00:00.000+00:00",
        "endTime": "2025-06-29T15:00:00.000+00:00",
        "status": "COMPLETED",
        "amenitiesCount": 1,
        "totalCost": 500.0,
        "payment": null,
        "accessCode": "ABC345"
      },
      {
        "id": "res016",
        "reservationDate": "2023-05-20T00:00:00.000+00:00",
        "startTime": "2023-01-10T09:00:00.000+00:00",
        "endTime": "2023-01-10T13:00:00.000+00:00",
        "status": "COMPLETED",
        "amenitiesCount": 3,
        "totalCost": 800.0,
        "payment": null,
        "accessCode": "DEF678"
      },
      {
        "id": "res018",
        "reservationDate": "2023-05-25T00:00:00.000+00:00",
        "startTime": "2023-01-10T09:00:00.000+00:00",
        "endTime": "2023-01-10T13:00:00.000+00:00",
        "status": "COMPLETED",
        "amenitiesCount": 3,
        "totalCost": 800.0,
        "payment": null,
        "accessCode": "DEF890"
      },
      {
        "id": "res021",
        "reservationDate": "2023-08-14T00:00:00.000+00:00",
        "startTime": "2023-01-10T09:00:00.000+00:00",
        "endTime": "2023-01-10T13:00:00.000+00:00",
        "status": "CANCELLED",
        "amenitiesCount": 3,
        "totalCost": 800.0,
        "payment": null,
        "accessCode": "A1V2G3"
      },
      {
        "id": "res022",
        "reservationDate": "2025-06-26T00:00:00.000+00:00",
        "startTime": "2025-06-26T17:50:00.000+00:00",
        "endTime": "2025-06-26T18:00:00.000+00:00",
        "status": "COMPLETED",
        "amenitiesCount": 5,
        "totalCost": 800.0,
        "payment": null,
        "accessCode": "A1V2ZZ"
      }
    ]


}
