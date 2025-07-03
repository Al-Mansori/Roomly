import { Component, signal } from '@angular/core';
import { SideNavbarComponent } from "../../side-navbar/side-navbar.component";
import { FormBuilder, FormGroup, FormsModule, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { BehaviorSubject, Subscription } from 'rxjs';
import { IOffer } from '../../../interfaces/iworkspace';
import { OfferService } from '../../../core/services/offer/offer.service';
import Swal from 'sweetalert2';

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
  selectedOffer = signal<IOffer | null>(null); // New signal for selected offer
  offerForm: FormGroup;

  constructor(
    private offerService: OfferService,
    private route: ActivatedRoute,
    private fb: FormBuilder
  ) {
    this.offerForm = this.fb.group({
      id: [''],
      offerTitle: ['', Validators.required],
      description: ['', Validators.required],
      discountPercentage: ['', [Validators.required, Validators.pattern(/^\d*\.?\d+$/), Validators.min(0), Validators.max(100)]],
      validFrom: ['', Validators.required],
      validTo: ['', Validators.required],
      status: ['Active']
    });
  }

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
  selectOffer(offer: IOffer): void {
    this.selectedOffer.set(offer);
  }

  deselectOffer(): void {
    // this.selectedOffer.set(null);
    this.selectedOffer.set(null);
    this.offerForm.reset();
    this.offerForm.patchValue({ status: 'Active' });
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

  confirmDeleteOffer(offerId: string): void {
    Swal.fire({
      title: 'Are you sure?',
      text: 'This will permanently delete the offer!',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: 'Yes, delete it!'
    }).then((result) => {
      if (result.isConfirmed) {
        this.deleteOffer(offerId);
      }
    });
  }
  deleteOffer(offerId: string): void {
    if (!this.roomId) return;
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    if (!staffId) return;

    this.offerService.deleteOffer(offerId).subscribe({
      next: (response) => {
        console.log('Offer deleted:', response.body);
        this.offersSubject.next(this.offersSubject.value.filter(o => o.id !== offerId));
        this.deselectOffer();
        Swal.fire('Deleted!', 'Offer has been removed.', 'success');
      },
      error: (err) => {
        console.error('Error deleting offer:', err);
        Swal.fire('Error!', 'Failed to delete offer.', 'error');
      }
    });
  }

  // editOffer(): void {
  //   if (!this.selectedOffer() || this.selectedOffer()!.status !== 'present') return;
  //   this.offerForm.patchValue(this.selectedOffer());
  //   this.openModal();
  // }

  reapplyOffer(): void {
    if (!this.selectedOffer() || this.selectedOffer()!.status !== 'expired') return;
    this.offerForm.patchValue({
      ...this.selectedOffer(),
      offerTitle: { value: this.selectedOffer()!.offerTitle, disabled: true },
      description: { value: this.selectedOffer()!.description, disabled: true },
      discountPercentage: { value: this.selectedOffer()!.discountPercentage, disabled: true },
      status: { value: this.selectedOffer()!.status, disabled: true }
    });
    this.openModal();
  }

  private openModal(): void {
    const modal = document.getElementById('addOfferModal');
    if (modal) {
      modal.classList.add('show');
      document.body.classList.add('modal-open');
      const backdrop = document.createElement('div');
      backdrop.className = 'modal-backdrop fade show';
      document.body.appendChild(backdrop);
    }
  }
  onAddOffer(): void {
    if (!this.offerForm.valid || !this.roomId) return;

    const offer: IOffer = this.offerForm.value;
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    if (!staffId) return;

    if (this.selectedOffer() && this.selectedOffer()!.status === 'expired') {
      this.offerService.editOffer(staffId, this.roomId, offer).subscribe({
        next: (response) => {
          console.log('Offer reapplied:', response.body);
          this.updateOffers(offer);
          this.closeModal();
          Swal.fire('Success!', 'Offer reapplied successfully.', 'success');
        },
        error: (err) => {
          console.error('Error reapplying offer:', err);
          Swal.fire('Error!', 'Failed to reapply offer.', 'error');
        }
      });
    } else if (this.selectedOffer() && this.selectedOffer()!.status === 'present') {
      this.offerService.editOffer(staffId, this.roomId, offer).subscribe({
        next: (response) => {
          console.log('Offer edited:', response.body);
          this.updateOffers(offer);
          this.closeModal();
          Swal.fire('Success!', 'Offer edited successfully.', 'success');
        },
        error: (err) => {
          console.error('Error editing offer:', err);
          Swal.fire('Error!', 'Failed to edit offer.', 'error');
        }
      });
    }
  }

  private closeModal(): void {
    const modal = document.getElementById('addOfferModal');
    if (modal) {
      modal.classList.remove('show');
      document.body.classList.remove('modal-open');
      const backdrop = document.querySelector('.modal-backdrop');
      if (backdrop) backdrop.remove();
    }
    this.deselectOffer();
  }
  private updateOffers(offer: IOffer): void {
    const currentOffers = this.offersSubject.value;
    const offerIndex = currentOffers.findIndex(o => o.id === offer.id);
    if (offerIndex > -1) {
      currentOffers[offerIndex] = { ...offer, status: new Date() > new Date(offer.validTo) ? 'expired' : 'present' };
    } else {
      currentOffers.push({ ...offer, status: 'present' });
    }
    this.offersSubject.next(currentOffers);
  }
  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }


}
