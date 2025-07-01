import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-offers-all',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './offers-all.component.html',
  styleUrl: './offers-all.component.scss'
})
export class OffersAllComponent {
  offers = [
    { id: 1, title: 'Spring Sale', dateFrom: '2024-05-01', dateTo: '2024-05-15', startTime: '08:00 AM', endTime: '11:59 PM', status: 'present' },
    { id: 2, title: 'New Year Blast', dateFrom: '2024-01-01', dateTo: '2024-01-05', startTime: '09:00 AM', endTime: '10:00 PM', status: 'expired' },
    { id: 3, title: 'Summer Deal', dateFrom: '2024-06-01', dateTo: '2024-06-10', startTime: '08:00 AM', endTime: '08:00 PM', status: 'present' }
  ];
}
