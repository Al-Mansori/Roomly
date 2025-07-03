import { CommonModule } from '@angular/common';
import { Component, signal } from '@angular/core';
import { IOffer } from '../../../interfaces/iworkspace';
import { Subscription } from 'rxjs';
import { OfferService } from '../../../core/services/offer/offer.service';
import { AllOffersListComponent } from '../all-offers-list/all-offers-list.component';

@Component({
  selector: 'app-offers-present',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './offers-present.component.html',
  styleUrl: './offers-present.component.scss'
})
export class OffersPresentComponent {
  offers: IOffer[] = [];
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
            return new Date() <= validTo;
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
