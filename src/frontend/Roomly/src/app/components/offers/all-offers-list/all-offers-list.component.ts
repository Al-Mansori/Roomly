import { Component, signal } from '@angular/core';
import { SideNavbarComponent } from "../../side-navbar/side-navbar.component";
import { AbstractControl, FormBuilder, FormGroup, FormsModule, ReactiveFormsModule, ValidationErrors, ValidatorFn, Validators } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, Router, RouterLink, RouterLinkActive, RouterOutlet } from '@angular/router';
import { BehaviorSubject, Subscription } from 'rxjs';
import { IOffer } from '../../../interfaces/iworkspace';
import { OfferService } from '../../../core/services/offer/offer.service';
import Swal from 'sweetalert2';
import bootstrap from '../../../../main.server';
import { AfterViewInit, ViewChild, ElementRef } from '@angular/core';



@Component({
  selector: 'app-all-offers-list',
  standalone: true,
  imports: [SideNavbarComponent, FormsModule, CommonModule, RouterLink, RouterLinkActive, RouterOutlet, ReactiveFormsModule],
  templateUrl: './all-offers-list.component.html',
  styleUrl: './all-offers-list.component.scss'
})
export class AllOffersListComponent {

  @ViewChild('offerListModal') offerModalRef!: ElementRef;
  private modalInstance: any;

  ngAfterViewInit(): void {
    if (this.offerModalRef) {
      // Access Bootstrap Modal constructor from the global scope
      this.modalInstance = new (window as any).bootstrap.Modal(this.offerModalRef.nativeElement);
    }
  }


  offersSubject = new BehaviorSubject<IOffer[]>([]);
  offers$ = this.offersSubject.asObservable();
  public _roomId: string | null = null;
  private subscription = new Subscription();
  selectedOffer = signal<IOffer | null>(null); // New signal for selected offer
  filteredOffers: IOffer[] = [];
  searchTerm: string = '';
  filterStatus: 'all' | 'Active' | 'Inactive' = 'all';
  offerForm: FormGroup;
  private originalOffers: IOffer[] = [];

  constructor(
    private offerService: OfferService,
    private route: ActivatedRoute,
    private fb: FormBuilder,
    private router: Router
  ) {

    this.offerForm = this.fb.group({
      id: [''],
      offerTitle: ['', [Validators.required, Validators.minLength(5), Validators.maxLength(100)]],
      description: ['', [Validators.required, Validators.minLength(10), Validators.maxLength(500)]],
      discountPercentage: [
        '',
        [
          Validators.required,
          Validators.pattern(/^\d*\.?\d+$/),
          Validators.min(1),
          Validators.max(99)
        ]
      ],
      validFrom: ['', Validators.required],
      validTo: ['', Validators.required],
      status: ['Active', Validators.required]
    }, {
      validators: [this.dateRangeValidator()]
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
          Swal.fire('Error!', 'No room ID provided.', 'error');

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



  private fetchOffers(): void {
    if (!this._roomId) return;
    this.offerService.getOffersByRoom(this._roomId).subscribe({
      next: (offers) => {
        console.log('Fetched offers:', offers);
        // this.offersSubject.next(offers);
        this.originalOffers = offers; // new
        this.applyFilters();
      },
      error: (err) => {
        console.error('Error fetching offers:', err);
        // this.offersSubject.next([]);
        this.originalOffers = [];
        this.applyFilters();
        Swal.fire('Error!', 'Failed to fetch offers.', 'error');
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
    if (!staffId) {
      Swal.fire('Error!', 'No staff ID found.', 'error');
      return;
    }
    const token = localStorage.getItem('token') || sessionStorage.getItem('token');
    if (!token) {
      Swal.fire('Error!', 'No authentication token found.', 'error');
      return;
    }
    this.offerService.deleteOffer(offerId).subscribe({
      next: (response) => {
        console.log('Offer deleted:', response.body);
        this.offersSubject.next(this.offersSubject.value.filter(o => o.id !== offerId));
        this.applyFilters(); // new
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
  //   this.offerForm.patchValue(this.selectedOffer()!);
  //   this.openModal();
  // }
  editOffer(): void {
    if (!this.selectedOffer() || new Date(this.selectedOffer()!.validTo) < new Date()) return;
    this.offerForm.patchValue(this.selectedOffer()!);
    this.updateFormState();
    this.openModal();
  }

  // openModal(): void {
  //   const modal = document.getElementById('addOfferModal');
  //   if (modal) {
  //     modal.classList.add('show');
  //     modal.style.display = 'block'; // new
  //     document.body.classList.add('modal-open');
  //     const backdrop = document.createElement('div');
  //     backdrop.className = 'modal-backdrop fade show';
  //     document.body.appendChild(backdrop);
  //   }
  // }

  // public closeModal(): void {
  //   const modal = document.getElementById('addOfferModal');
  //   if (modal) {
  //     modal.classList.remove('show');
  //     modal.style.display = 'none';
  //     document.body.classList.remove('modal-open');
  //     const backdrop = document.querySelector('.modal-backdrop');
  //     if (backdrop) backdrop.remove();
  //   }
  //   this.deselectOffer();
  // }
  openModal(): void {
    if (this.modalInstance) {
      this.modalInstance.show();
    }
  }

  closeModal(): void {
    if (this.modalInstance) {
      this.modalInstance.hide();
    }
    this.deselectOffer();
  }


  // reapplyOffer(): void {
  //   if (!this.selectedOffer() || this.selectedOffer()!.status !== 'expired') return;
  //   const offer = this.selectedOffer()!;
  //   this.offerForm.patchValue(offer);
  //   this.updateFormState(); // Disable fields for reapply
  //   this.openModal();
  // }
  reapplyOffer(): void {
    if (!this.selectedOffer() || new Date(this.selectedOffer()!.validTo) >= new Date()) return;
    const offer = this.selectedOffer()!;
    this.offerForm.patchValue(offer);
    this.updateFormState();
    this.openModal();
  }
  onEditOffer(): void {
    if (!this.offerForm.valid || !this._roomId) return;

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
      roomId: this._roomId
    };

    this.offerService.editOffer(requestBody).subscribe({
      next: (response) => {
        console.log('Offer edited:', response.body || 'No response body');
        this.updateOffers(offer);
        this.closeModal();
        Swal.fire('Success!', 'Offer edited successfully.', 'success');
        this.fetchOffers();
      },
      error: (err) => {
        console.error('Error editing offer:', err);
        Swal.fire('Error!', 'Failed to edit offer.', 'error');
      }
    });
  }



  onAddOffer(): void {
    if (!this.offerForm.valid || !this._roomId) return;

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
      roomId: this._roomId
    };

    this.offerService.addOffer(requestBody).subscribe({
      next: (response) => {
        console.log('Offer added response:', response);
        const newOffer = response.body?.id ? { ...offer, id: response.body.id } : offer;
        this.updateOffers(newOffer);
        this.closeModal();
        Swal.fire('Success!', this.isReapplyOffer() ? 'Offer reapplied successfully.' : 'Offer created successfully.', 'success');
        this.fetchOffers();
      },
      error: (err) => {
        console.error('Error adding offer:', err);
        Swal.fire('Error!', 'Failed to add offer.', 'error');
      }
    });
  }




  private updateOffers(offer: IOffer): void {

    // const currentOffers = this.offersSubject.value;
    // const offerIndex = currentOffers.findIndex(o => o.id === offer.id);
    // if (offerIndex > -1) {
    //   currentOffers[offerIndex] = offer;
    // } else {
    //   currentOffers.push(offer);
    // }
    // this.offersSubject.next(currentOffers);
    // this.applyFilters();
    const currentOffers = [...this.originalOffers];
    const offerIndex = currentOffers.findIndex(o => o.id === offer.id);
    if (offerIndex > -1) {
      currentOffers[offerIndex] = offer;
    } else {
      currentOffers.push(offer);
    }
    this.originalOffers = currentOffers;
    this.applyFilters(); // تصفية بناءً على الجديد
  }

  private updateFormState(): void {
    // if (this.selectedOffer() && new Date(this.selectedOffer()!.validTo) < new Date())
    if (this.isReapplyOffer()) {
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
  ngOnDestroy(): void {
    this.subscription.unsubscribe();
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
  onSearch(event: Event): void {
    this.searchTerm = (event.target as HTMLInputElement).value.toLowerCase();
    this.applyFilters();
  }

  onFilterChange(event: Event): void {
    this.filterStatus = (event.target as HTMLSelectElement).value as 'all' | 'Active' | 'Inactive';
    this.applyFilters();
  }
  // applyFilters(): void {
  //   let filtered = [...this.offersSubject.value];
  //   if (this.searchTerm) {
  //     filtered = filtered.filter(offer =>
  //       (offer.id?.toLowerCase().includes(this.searchTerm) || '') ||
  //       offer.offerTitle.toLowerCase().includes(this.searchTerm)
  //     );
  //   }
  //   if (this.filterStatus !== 'all') {
  //     filtered = filtered.filter(offer => offer.status === this.filterStatus);
  //   }
  //   this.filteredOffers = filtered;
  //   this.offersSubject.next(filtered);
  // }
  applyFilters(): void {
    let filtered = [...this.originalOffers]; // <-- استخدم النسخة الأصلية

    if (this.searchTerm) {
      filtered = filtered.filter(offer =>
        (offer.id?.toLowerCase().includes(this.searchTerm) || '') ||
        offer.offerTitle.toLowerCase().includes(this.searchTerm)
      );
    }

    if (this.filterStatus !== 'all') {
      filtered = filtered.filter(offer => offer.status === this.filterStatus);
    }

    this.filteredOffers = filtered;
    this.offersSubject.next(filtered);
  }

  isEditOffer(): boolean {
    const offer = this.selectedOffer();
    if (!offer?.validTo) return false;
    return !!offer && new Date(offer.validTo) >= new Date();
  }

  isReapplyOffer(): boolean {
    const offer = this.selectedOffer();
    if (!offer?.validTo) return false;
    return !!offer && new Date(offer.validTo) < new Date();
  }

}
