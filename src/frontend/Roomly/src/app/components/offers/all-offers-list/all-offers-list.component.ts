import { Component, signal } from '@angular/core';
import { SideNavbarComponent } from "../../side-navbar/side-navbar.component";
import { FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { BehaviorSubject, Subscription } from 'rxjs';
import { IOffer } from '../../../interfaces/iworkspace';
import { OfferService } from '../../../core/services/offer/offer.service';
import Swal from 'sweetalert2';
import bootstrap from '../../../../main.server';


@Component({
  selector: 'app-all-offers-list',
  standalone: true,
  imports: [SideNavbarComponent, FormsModule, CommonModule, RouterLink, RouterLinkActive, RouterOutlet, ReactiveFormsModule],
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
  public _roomId: string | null = null;
  private subscription = new Subscription();
  selectedOffer = signal<IOffer | null>(null); // New signal for selected offer
  offerForm: FormGroup;

  constructor(
    private offerService: OfferService,
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private router: Router
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
        this._roomId = params.get('roomId');
        if (this._roomId) {
          this.fetchOffers();
        } else {
          console.error('No roomId provided in route');
        }
      })
    );
  }
  getRoomId(): string | null {
    return this._roomId;
  }
  selectOffer(offer: IOffer): void {
    this.selectedOffer.set(offer);
    this.updateFormState();
  }

  deselectOffer(): void {
    // this.selectedOffer.set(null);
    this.selectedOffer.set(null);
    this.offerForm.reset();
    this.offerForm.patchValue({ status: 'Active' });
    this.offerForm.enable();
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
    if (!this._roomId) return;
    this.offerService.getOffersByRoom(this._roomId).subscribe({
      next: (offers) => {
        console.log('Fetched offers:', offers); // Debug log
        const currentDate = new Date();
        const updatedOffers = Array.isArray(offers) ? offers.map(offer => {
          const validTo = new Date(offer.validTo);
          return {
            ...offer,
            status: currentDate > validTo ? 'expired' : 'present'
          };
        }) : [];
        this.offersSubject.next(updatedOffers);
      },
      error: (err) => {
        console.error('Error fetching offers:', err);
        this.offersSubject.next([]); // Set to empty array on error
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
    if (!this._roomId) return;
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

  editOffer(): void {
    if (!this.selectedOffer() || this.selectedOffer()!.status !== 'present') return;
    this.offerForm.patchValue(this.selectedOffer()!);
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
  // reapplyOffer(): void {
  //   if (!this.selectedOffer() || this.selectedOffer()!.status !== 'expired') return;
  //   const offer = this.selectedOffer()!;
  //   this.offerForm.patchValue({
  //     ...offer,
  //     offerTitle: { value: offer.offerTitle, disabled: true },
  //     description: { value: offer.description, disabled: true },
  //     discountPercentage: { value: offer.discountPercentage, disabled: true },
  //     status: { value: offer.status, disabled: true }
  //   });
  //   this.openModal();
  // }
  reapplyOffer(): void {
    if (!this.selectedOffer() || this.selectedOffer()!.status !== 'expired') return;
    const offer = this.selectedOffer()!;
    this.offerForm.patchValue(offer);
    this.updateFormState(); // Disable fields for reapply
    this.openModal();
  }


  // onAddOffer(): void {
  //   if (!this.offerForm.valid || !this._roomId) return;

  //   const offer: IOffer = this.offerForm.value;
  //   const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
  //   const staffId = user?.id;
  //   if (!staffId) return;

  //   if (this.selectedOffer() && this.selectedOffer()!.status === 'expired') {
  //     this.offerService.editOffer(staffId, this._roomId, offer).subscribe({
  //       next: (response) => {
  //         console.log('Offer reapplied:', response.body);
  //         this.updateOffers(offer);
  //         this.closeModal();
  //         Swal.fire('Success!', 'Offer reapplied successfully.', 'success');
  //       },
  //       error: (err) => {
  //         console.error('Error reapplying offer:', err);
  //         Swal.fire('Error!', 'Failed to reapply offer.', 'error');
  //       }
  //     });
  //   } else if (this.selectedOffer() && this.selectedOffer()!.status === 'present') {
  //     this.offerService.editOffer(staffId, this._roomId, offer).subscribe({
  //       next: (response) => {
  //         console.log('Offer edited:', response.body);
  //         this.updateOffers(offer);
  //         this.closeModal();
  //         Swal.fire('Success!', 'Offer edited successfully.', 'success');
  //       },
  //       error: (err) => {
  //         console.error('Error editing offer:', err);
  //         Swal.fire('Error!', 'Failed to edit offer.', 'error');
  //       }
  //     });
  //   } else {
  //     // New offer creation
  //     this.offerService.addOffer(staffId, this._roomId, offer).subscribe({
  //       next: (response) => {
  //         console.log('Offer added:', response.body);
  //         const newOffer = response.body?.id ? { ...offer, id: response.body.id } : offer;
  //         this.updateOffers(newOffer);
  //         this.closeModal();
  //         Swal.fire('Success!', 'Offer created successfully.', 'success');
  //       },
  //       error: (err) => {
  //         console.error('Error adding offer:', err);
  //         Swal.fire('Error!', 'Failed to add offer.', 'error');
  //       }
  //     });
  //   }
  // }

  onAddOffer(): void {
    if (!this.offerForm.valid || !this._roomId) return;

    const offer: IOffer = this.offerForm.value;
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    if (!staffId) return;

    const requestBody = {
      ...offer,
      staffId: staffId,
      roomId: this._roomId
    };

    this.offerService.addOffer(requestBody).subscribe({
      next: (response) => {
        console.log('Offer added response:', response);
        const newOffer = response.body?.id ? { ...offer, id: response.body.id } : offer;
        this.updateOffers(newOffer);
        this.closeModal();
        Swal.fire('Success!', 'Offer created successfully.', 'success');
        this.fetchOffers(); // Refresh offers after adding
      },
      error: (err) => {
        console.error('Error adding offer:', err);
        Swal.fire('Error!', 'Failed to add offer.', 'error');
      }
    });
  }

  public closeModal(): void {
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

  private updateFormState(): void {
    if (this.selectedOffer() && this.selectedOffer()!.status === 'expired') {
      this.offerForm.get('offerTitle')?.disable();
      this.offerForm.get('description')?.disable();
      this.offerForm.get('discountPercentage')?.disable();
      this.offerForm.get('status')?.disable();
    } else {
      this.offerForm.get('offerTitle')?.enable();
      this.offerForm.get('description')?.enable();
      this.offerForm.get('discountPercentage')?.enable();
      this.offerForm.get('status')?.enable();
    }
  }
  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }


}
