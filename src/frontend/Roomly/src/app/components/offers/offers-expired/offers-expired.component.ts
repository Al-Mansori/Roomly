import { CommonModule } from '@angular/common';
import { Component, signal } from '@angular/core';
import { OfferService } from '../../../core/services/offer/offer.service';
import { IOffer } from '../../../interfaces/iworkspace';
import { Subscription } from 'rxjs';
import { AllOffersListComponent } from '../all-offers-list/all-offers-list.component';

@Component({
  selector: 'app-offers-expired',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './offers-expired.component.html',
  styleUrl: './offers-expired.component.scss'
})
export class OffersExpiredComponent {

  offers: IOffer[] = [];
  private now = new Date();
  private subscription = new Subscription();

  constructor(
    public parent: AllOffersListComponent // Access parent data
  ) { }

  ngOnInit(): void {
    this.subscription.add(
      this.parent.offers$.subscribe({
        next: (data: IOffer[]) => {
          this.offers = data.filter(offer => {
            const validTo = new Date(offer.validTo);
            return new Date() > validTo;
          });
        },
        error: (err) => {
          console.error('Error loading offers:', err);
        }
      })
    );
  }


  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }
}
