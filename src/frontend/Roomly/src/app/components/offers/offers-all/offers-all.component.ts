import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AllOffersListComponent } from '../all-offers-list/all-offers-list.component';
import { OfferService } from '../../../core/services/offer/offer.service';
import { Subscription } from 'rxjs';
import { IOffer } from '../../../interfaces/iworkspace';

@Component({
  selector: 'app-offers-all',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './offers-all.component.html',
  styleUrl: './offers-all.component.scss'
})
export class OffersAllComponent {
  offers: IOffer[] = [];
  private subscription = new Subscription();

  constructor(
    public parent: AllOffersListComponent, // Access parent data
    
  ) {}

  ngOnInit(): void {
    this.subscription.add(
      this.parent.offers$.subscribe({
        next: (data: IOffer[]) => {
          this.offers = data; // No filtering for "All"
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
