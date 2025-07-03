import { Component } from '@angular/core';
import { SideNavbarComponent } from "../../side-navbar/side-navbar.component";
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { BehaviorSubject, Subscription } from 'rxjs';
import { IOffer } from '../../../interfaces/iworkspace';
import { OfferService } from '../../../core/services/offer/offer.service';

@Component({
  selector: 'app-all-offers-list',
  standalone: true,
  imports: [SideNavbarComponent, FormsModule, CommonModule, RouterLink, RouterLinkActive, RouterOutlet],
  templateUrl: './all-offers-list.component.html',
  styleUrl: './all-offers-list.component.scss'
})
export class AllOffersListComponent {

  // offers = () => [
  //   {
  //     id: '1',
  //     title: 'Weekend Special Offer',
  //     dateFrom: 'Friday, 28 May 2024',
  //     dateTo: 'Sunday, 30 May 2024',
  //     startTime: '08:00 AM',
  //     endTime: '11:59 PM',
  //     status: 'present',
  //   },
  //   {
  //     id: '2',
  //     title: 'Holiday Discount',
  //     dateFrom: 'Monday, 15 Apr 2024',
  //     dateTo: 'Wednesday, 17 Apr 2024',
  //     startTime: '09:00 AM',
  //     endTime: '10:00 PM',
  //     status: 'expired',
  //   },
  //   {
  //     id: '3',
  //     title: 'Holiday Discount',
  //     dateFrom: 'Monday, 15 Apr 2024',
  //     dateTo: 'Wednesday, 17 Apr 2024',
  //     startTime: '09:00 AM',
  //     endTime: '10:00 PM',
  //     status: 'expired',
  //   },
  //   {
  //     id: '4',
  //     title: 'Holiday Discount',
  //     dateFrom: 'Monday, 15 Apr 2024',
  //     dateTo: 'Wednesday, 17 Apr 2024',
  //     startTime: '09:00 AM',
  //     endTime: '10:00 PM',
  //     status: 'present',
  //   }
  // ];

  private offersSubject = new BehaviorSubject<IOffer[]>([]);
  offers$ = this.offersSubject.asObservable();
  private roomId: string | null = null;
  private subscription = new Subscription();

  constructor(
    private offerService: OfferService,
    private route: ActivatedRoute
  ) { }

  ngOnInit(): void {
    // this.fetchOffers();
    this.subscription.add(
      this.route.paramMap.subscribe(params => {
        this.roomId = params.get('roomId');
        if (this.roomId) {
          this.fetchOffers();
        } else {
          console.error('No roomId provided in route');
        }
      })
    );
  }

  // private fetchOffers(): void {
  //   const roomId = 'rm001'; // Hardcoded for now; replace with dynamic value if needed
  //   this.offerService.getOffersByRoom(roomId).subscribe({
  //     next: (offers) => {
  //       // Determine status based on current date
  //       const currentDate = new Date();
  //       const updatedOffers = offers.map(offer => {
  //         const validTo = new Date(offer.validTo);
  //         return {
  //           ...offer,
  //           status: currentDate > validTo ? 'expired' : 'present'
  //         };
  //       });
  //       this.offersSubject.next(updatedOffers);
  //     },
  //     error: (err) => {
  //       console.error('Error fetching offers:', err);
  //     }
  //   });
  // }
  private fetchOffers(): void {
    if (!this.roomId) return;
    this.offerService.getOffersByRoom(this.roomId).subscribe({
      next: (offers) => {
        const currentDate = new Date();
        const updatedOffers = offers.map(offer => {
          const validTo = new Date(offer.validTo);
          return {
            ...offer,
            status: currentDate > validTo ? 'expired' : 'present'
          };
        });
        this.offersSubject.next(updatedOffers);
      },
      error: (err) => {
        console.error('Error fetching offers:', err);
      }
    });
  }
  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
