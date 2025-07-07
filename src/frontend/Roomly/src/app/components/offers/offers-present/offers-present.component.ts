import { CommonModule } from '@angular/common';
import { Component, OnDestroy, OnInit, signal } from '@angular/core';
import { IOffer } from '../../../interfaces/iworkspace';
import { Subscription } from 'rxjs';
import { OfferService } from '../../../core/services/offer/offer.service';
import { AllOffersListComponent } from '../all-offers-list/all-offers-list.component';
import { AbstractControl, FormBuilder, FormGroup, ReactiveFormsModule, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-offers-present',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './offers-present.component.html',
  styleUrl: './offers-present.component.scss'
})
export class OffersPresentComponent implements OnInit, OnDestroy {
  offers: IOffer[] = [];
  offerForm: FormGroup;
  selectedOffer: IOffer | null = null;
  private subscription = new Subscription();

  constructor(
    public parent: AllOffersListComponent,
    private fb: FormBuilder,
    private offerService: OfferService
  ) {
    this.offerForm = this.fb.group({
      id: [''],
      offerTitle: ['', [Validators.required, Validators.minLength(5), Validators.maxLength(100)]],
      description: ['', [Validators.required, Validators.minLength(10), Validators.maxLength(500)]],
      discountPercentage: [
        '',
        [Validators.required, Validators.pattern(/^\d*\.?\d+$/), Validators.min(1), Validators.max(99)]
      ],
      validFrom: ['', Validators.required],
      validTo: ['', Validators.required],
      status: ['Active', Validators.required]
    }, { validators: this.dateRangeValidator() });
  }

  ngOnInit(): void {
    this.subscription.add(
      this.parent.offers$.subscribe({
        next: (data: IOffer[]) => {
          this.offers = data.filter(offer => this.isPresent(offer));
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

  isPresent(offer: IOffer): boolean {
    return new Date(offer.validTo) >= new Date();
  }

  selectOffer(offer: IOffer): void {
    this.selectedOffer = offer;
  }

  editOffer(offer: IOffer): void {
    if (!offer || new Date(offer.validTo) < new Date()) return;
    this.selectedOffer = offer;
    this.offerForm.patchValue({
      ...offer,
      validFrom: new Date(offer.validFrom).toISOString().split('T')[0],
      validTo: new Date(offer.validTo).toISOString().split('T')[0]
    });
    this.offerForm.enable();
  }

  resetForm(): void {
    this.selectedOffer = null;
    this.offerForm.reset();
    this.offerForm.patchValue({ status: 'Active' });
    this.offerForm.enable();
  }

  onSubmit(): void {
    if (!this.offerForm.valid || !this.parent.getRoomId()) return;

    const token = localStorage.getItem('token') || sessionStorage.getItem('token');
    if (!token) {
      Swal.fire('Error!', 'No authentication token found.', 'error');
      return;
    }

    const offer: IOffer = this.offerForm.value;
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    if (!staffId) {
      Swal.fire('Error!', 'No staff ID found.', 'error');
      return;
    }

    const requestBody = {
      ...offer,
      staffId: staffId,
      roomId: this.parent.getRoomId()
    };

    this.offerService.editOffer(requestBody).subscribe({
      next: (response) => {
        console.log('Offer edited:', response.body || 'No response body');
        this.updateOffers(offer);
        this.resetForm();
        Swal.fire('Success!', 'Offer edited successfully.', 'success');
      },
      error: (err) => {
        console.error('Error editing offer:', err);
        Swal.fire('Error!', 'Failed to edit offer.', 'error');
      }
    });
  }

  private updateOffers(offer: IOffer): void {
    const currentOffers = this.parent.offersSubject.value;
    const offerIndex = currentOffers.findIndex(o => o.id === offer.id);
    if (offerIndex > -1) {
      currentOffers[offerIndex] = offer;
    }
    this.parent.offersSubject.next(currentOffers);
    this.parent.applyFilters();
  }

  private dateRangeValidator(): ValidatorFn {
    return (group: AbstractControl): ValidationErrors | null => {
      const from = new Date(group.get('validFrom')?.value);
      const to = new Date(group.get('validTo')?.value);
      const today = new Date(new Date().setHours(0, 0, 0, 0));
      if (!from || !to || isNaN(+from) || isNaN(+to)) return null;
      if (from <= to && (!group.get('id')?.value || new Date(group.get('validTo')?.value) >= today) && from < today) {
        return { validFromInPast: true };
      }
      return from <= to ? null : { dateRangeInvalid: true };
    };
  }
}