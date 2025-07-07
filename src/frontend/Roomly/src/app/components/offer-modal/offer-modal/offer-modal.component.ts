import { Component, inject, signal } from '@angular/core';
import { AbstractControl, FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { OfferService } from '../../../core/services/offer/offer.service';
import { IOffer } from '../../../interfaces/iworkspace';
import Swal from 'sweetalert2';
import { OfferModalService } from '../../../core/services/offer-modal/offer-modal.service';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-offer-modal',
  standalone: true,
  imports: [FormsModule, CommonModule, ReactiveFormsModule],
  templateUrl: './offer-modal.component.html',
  styleUrl: './offer-modal.component.scss'
})
export class OfferModalComponent {
  private readonly fb = inject(FormBuilder);
  private readonly offerService = inject(OfferService);
  private readonly modalService = inject(OfferModalService);

  offerForm: FormGroup;
  mode = signal<'add' | 'edit' | 'reapply'>('add');
  roomId = signal<string | null>(null);
  selectedOffer = signal<IOffer | null>(null);

  constructor() {
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

    // Subscribe to modal service to handle open requests
    this.modalService.modalState$.subscribe(({ mode, offer, roomId }) => {
      this.roomId.set(roomId);
      this.mode.set(mode);
      this.selectedOffer.set(offer);
      if (offer) {
        this.offerForm.patchValue(offer);
        this.updateFormState();
      } else {
        this.offerForm.reset();
        this.offerForm.patchValue({ status: 'Active' });
        this.offerForm.enable();
      }
      if (mode !== 'add') {
        this.openModal();
      }
    });
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

  private updateFormState(): void {
    if (this.mode() === 'reapply') {
      this.offerForm.get('offerTitle')?.disable();
      this.offerForm.get('description')?.disable();
      this.offerForm.get('discountPercentage')?.disable();
      this.offerForm.get('status')?.disable();
      this.offerForm.get('validFrom')?.enable();
      this.offerForm.get('validTo')?.enable();
    } else {
      this.offerForm.get('offerTitle')?.enable();
      this.offerForm.get('description')?.enable();
      this.offerForm.get('discountPercentage')?.enable();
      this.offerForm.get('status')?.enable();
      this.offerForm.get('validFrom')?.enable();
      this.offerForm.get('validTo')?.enable();
    }
  }

  onAddOffer(): void {
    if (!this.offerForm.valid || !this.roomId()) return;

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
      roomId: this.roomId()
    };

    this.offerService.addOffer(requestBody).subscribe({
      next: (response) => {
        console.log('Offer added response:', response);
        const newOffer = response.body?.id ? { ...offer, id: response.body.id } : offer;
        this.modalService.notifyOfferUpdated(newOffer);
        this.closeModal();
        Swal.fire('Success!', this.mode() === 'reapply' ? 'Offer reapplied successfully.' : 'Offer created successfully.', 'success');
      },
      error: (err) => {
        console.error('Error adding offer:', err);
        Swal.fire('Error!', 'Failed to add offer.', 'error');
      }
    });
  }

  onEditOffer(): void {
    if (!this.offerForm.valid || !this.roomId()) return;

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
      roomId: this.roomId()
    };

    this.offerService.editOffer(requestBody).subscribe({
      next: (response) => {
        console.log('Offer edited:', response.body || 'No response body');
        this.modalService.notifyOfferUpdated(offer);
        this.closeModal();
        Swal.fire('Success!', 'Offer edited successfully.', 'success');
      },
      error: (err) => {
        console.error('Error editing offer:', err);
        Swal.fire('Error!', 'Failed to edit offer.', 'error');
      }
    });
  }

  openModal(): void {
    console.log('openModal called');
    const modal = document.getElementById('offerModal');
    if (modal) {
      modal.classList.add('show');
      modal.style.display = 'block';
      modal.setAttribute('aria-modal', 'true');
      modal.removeAttribute('aria-hidden');
      document.body.classList.add('modal-open');
      const backdrop = document.createElement('div');
      backdrop.classList.add('modal-backdrop', 'fade', 'show');
      document.body.appendChild(backdrop);
    } else {
      console.error('Offer modal element not found');
    }
  }

  closeModal(): void {
    const modal = document.getElementById('offerModal');
    if (modal) {
      modal.classList.remove('show');
      modal.style.display = 'none';
      modal.setAttribute('aria-hidden', 'true');
      modal.removeAttribute('aria-modal');
      document.body.classList.remove('modal-open');
      const backdrop = document.querySelector('.modal-backdrop');
      if (backdrop) backdrop.remove();
    }
    this.selectedOffer.set(null);
    this.mode.set('add');
    this.offerForm.reset();
    this.offerForm.patchValue({ status: 'Active' });
    this.offerForm.enable();
  }

}
