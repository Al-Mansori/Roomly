import { CommonModule } from '@angular/common';
import { Component, signal } from '@angular/core';

@Component({
  selector: 'app-offers-present',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './offers-present.component.html',
  styleUrl: './offers-present.component.scss'
})
export class OffersPresentComponent {
      allOffers = [
      { id: 1, title: 'Spring Sale', dateFrom: 'May 1, 2024', dateTo: 'May 3, 2024', startTime: '8:00 AM', endTime: '11:59 PM', status: 'expired' },
      { id: 2, title: 'Eid Deal', dateFrom: 'June 5, 2024', dateTo: 'June 10, 2024', startTime: '9:00 AM', endTime: '10:00 PM', status: 'present' },
      { id: 3, title: 'Back to School', dateFrom: 'August 15, 2024', dateTo: 'August 20, 2024', startTime: '10:00 AM', endTime: '9:00 PM', status: 'expired' }
    ];
  
    offers = signal(this.allOffers.filter(o => o.status === 'present'));
  

}
