import { Component, ElementRef, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { AllOffersListComponent } from '../all-offers-list/all-offers-list.component';
import { OfferService } from '../../../core/services/offer/offer.service';
import { Subscription } from 'rxjs';
import { IOffer } from '../../../interfaces/iworkspace';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-offers-all',
  standalone: true,
  imports: [FormsModule, CommonModule, ReactiveFormsModule],
  templateUrl: './offers-all.component.html',
  styleUrl: './offers-all.component.scss'
})
export class OffersAllComponent implements OnInit, OnDestroy {
  offers: IOffer[] = [];
  offerForm: FormGroup;
  selectedOffer: IOffer | null = null;
  mode: 'edit' | 'reapply' = 'edit';
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
          console.log('OffersAllComponent received offers:', data);
          this.offers = data;
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

  isExpired(offer: IOffer): boolean {
    return new Date(offer.validTo) < new Date();
  }

  selectOffer(offer: IOffer): void {
    this.selectedOffer = offer;
  }

  editOffer(offer: IOffer): void {
    if (!offer || new Date(offer.validTo) < new Date()) return;
    this.mode = 'edit';
    this.selectedOffer = offer;
    this.offerForm.patchValue({
      ...offer,
      validFrom: new Date(offer.validFrom).toISOString().split('T')[0],
      validTo: new Date(offer.validTo).toISOString().split('T')[0]
    });
    this.updateFormState();
  }

  reapplyOffer(offer: IOffer): void {
    if (!offer || new Date(offer.validTo) >= new Date()) return;
    this.mode = 'reapply';
    this.selectedOffer = offer;
    this.offerForm.patchValue({
      ...offer,
      validFrom: '',
      validTo: ''
    });
    this.updateFormState();
  }

  resetForm(): void {
    this.selectedOffer = null;
    this.mode = 'edit';
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

    if (this.mode === 'edit') {
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
    } else if (this.mode === 'reapply') {
      this.offerService.addOffer(requestBody).subscribe({
        next: (response) => {
          console.log('Offer reapplied response:', response);
          const newOffer = response.body?.id ? { ...offer, id: response.body.id } : offer;
          this.updateOffers(newOffer);
          this.resetForm();
          Swal.fire('Success!', 'Offer reapplied successfully.', 'success');
        },
        error: (err) => {
          console.error('Error reapplying offer:', err);
          Swal.fire('Error!', 'Failed to reapply offer.', 'error');
        }
      });
    }
  }

  private updateOffers(offer: IOffer): void {
    const currentOffers = this.parent.offersSubject.value;
    const offerIndex = currentOffers.findIndex(o => o.id === offer.id);
    if (offerIndex > -1) {
      currentOffers[offerIndex] = offer;
    } else {
      currentOffers.push(offer);
    }
    this.parent.offersSubject.next(currentOffers);
    this.parent.applyFilters();
  }

  private updateFormState(): void {
    if (this.mode === 'reapply') {
      this.offerForm.get('offerTitle')?.disable();
      this.offerForm.get('description')?.disable();
      this.offerForm.get('discountPercentage')?.disable();
      this.offerForm.get('status')?.disable();
      this.offerForm.get('validFrom')?.enable();
      this.offerForm.get('validTo')?.enable();
    } else {
      this.offerForm.enable();
    }
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