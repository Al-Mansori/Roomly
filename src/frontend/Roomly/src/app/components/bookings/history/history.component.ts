import { CommonModule } from '@angular/common';
import { Component } from '@angular/core';

@Component({
  selector: 'app-history',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './history.component.html',
  styleUrl: './history.component.scss'
})
export class HistoryComponent {

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

  bookings = this.reservations.filter(res =>
    new Date(res.endTime) < this.now 
    // res.status.toLowerCase() === 'cancelled'
  );

}
