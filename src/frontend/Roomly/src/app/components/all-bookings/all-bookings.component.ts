import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

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
  activeTab = 'all';
  indicatorPosition = 0;
  
  tabs = [
    { id: 'all', label: 'All' },
    { id: 'requests', label: 'Requests' },
    { id: 'upcoming', label: 'Upcoming' },
    { id: 'ongoing', label: 'Ongoing' },
    { id: 'history', label: 'History' }
  ];

  bookings: Booking[] = [
    {
      id: '153324',
      room: 'Meeting room A2',
      branch: 'Maadi branch 1',
      image: 'https://via.placeholder.com/300x200?text=Meeting+A2',
      startDate: new Date('2025-02-12T09:30:00'),
      endDate: new Date('2025-02-12T10:00:00'),
      seats: 5,
      paymentMethod: 'Cash',
      price: 200,
      status: 'upcoming',
      timeRemaining: '00:24:45'
    },
    {
      id: '153345',
      room: 'Desk D12',
      branch: 'Maadi branch 1',
      image: 'https://via.placeholder.com/300x200?text=Desk+D12',
      startDate: new Date('2025-02-12T09:30:00'),
      endDate: new Date('2025-02-12T10:00:00'),
      seats: 1,
      paymentMethod: 'Card',
      price: 600,
      status: 'ongoing',
      timeRemaining: '01:34:05'
    },
    {
      id: '153366',
      room: 'Meeting room A3',
      branch: 'Maadi branch 1',
      image: 'https://via.placeholder.com/300x200?text=Meeting+A3',
      startDate: new Date('2025-02-12T09:30:00'),
      endDate: new Date('2025-02-12T10:00:00'),
      seats: 2,
      paymentMethod: 'Cash',
      price: 200,
      status: 'upcoming',
      timeRemaining: '00:24:45'
    }
  ];

  get filteredBookings(): Booking[] {
    if (this.activeTab === 'all') return this.bookings;
    return this.bookings.filter(b => b.status === this.activeTab);
  }

  setActiveTab(tabId: string): void {
    this.activeTab = tabId;
    const index = this.tabs.findIndex(t => t.id === tabId);
    this.indicatorPosition = index * 100; // Adjust based on your design
  }
}
