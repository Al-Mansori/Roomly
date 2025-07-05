import { Component } from '@angular/core';
import { OfferService } from '../../core/services/offer/offer.service';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";

@Component({
  selector: 'app-offers-recommendations',
  standalone: true,
  imports: [SideNavbarComponent],
  templateUrl: './offers-recommendations.component.html',
  styleUrl: './offers-recommendations.component.scss'
})
export class OffersRecommendationsComponent {
  recommendations: any[] = [];
  isLoading = false;
  error: string | null = null;

  constructor(private offerService: OfferService) {}

  ngOnInit(): void {
    this.loadRecommendations();
  }

  loadRecommendations(): void {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id || null;
    if (!staffId) {
      this.error = 'User not authenticated';
      console.error(this.error);
      return;
    }

    this.isLoading = true;
    this.offerService.getRecommendations(staffId).subscribe({
      next: (response) => {
        this.recommendations = response.recommendations;
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Failed to load recommendations. Please try again.';
        this.isLoading = false;
        console.error('Error fetching recommendations:', err);
      }
    });
  }

}
