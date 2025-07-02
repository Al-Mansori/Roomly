import { Component, signal } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { SwiperOptions } from 'swiper';
import { Router } from '@angular/router';
import { IReview, IRoom, IWorkspace } from '../../interfaces/iworkspace';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { AuthStateService } from '../../core/services/auth-state/auth-state.service';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { HttpClientJsonpModule } from '@angular/common/http';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-my-workspaces',
  standalone: true,
  imports: [SideNavbarComponent, ReactiveFormsModule, HttpClientJsonpModule, CommonModule],
  templateUrl: './my-workspaces.component.html',
  styleUrl: './my-workspaces.component.scss'
})
export class MyWorkspacesComponent {
  workspaces = signal<IWorkspace[]>([]);
  selectedWorkspace = signal<IWorkspace | null>(null);
  selectedWorkspaceRooms = signal<IRoom[]>([]);
  // selectedWorkspaceReviews = signal<IReview[]>([]);
  isLoading = signal(true);
  error = signal<string | null>(null);
  offerForm: FormGroup;


  // Swiper configuration
  swiperConfig: SwiperOptions = {
    slidesPerView: 2,
    spaceBetween: 15,
    navigation: true,
    breakpoints: {
      0: { slidesPerView: 1 },
      576: { slidesPerView: 1 },
      768: { slidesPerView: 2 },
      992: { slidesPerView: 2 }
    }
  };

  constructor(private router: Router,
    private workspaceService: WorkspaceService,
    private authState: AuthStateService,
    private fb: FormBuilder

  ) {
    this.offerForm = this.fb.group({
      title: ['', Validators.required],
      dateFrom: ['', Validators.required],
      dateTo: ['', Validators.required],
      timeFrom: ['', Validators.required],
      timeTo: ['', Validators.required],
      percentage: ['', [Validators.required, Validators.pattern(/^\d+$/), Validators.min(0), Validators.max(100)]]
    });
  }
  ngOnInit(): void {
    this.fetchWorkspaces();
  }
  // fetchWorkspaces(): void {
  //   this.isLoading.set(true);
  //   this.error.set(null);

  //   const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
  //   const staffId = user?.id;

  //   if (!staffId) {
  //     this.error.set('User not authenticated');
  //     this.isLoading.set(false);
  //     return;
  //   }

  //   this.workspaceService.getWorkspacesByStaff("stf001").subscribe({
  //     next: (workspaces) => {
  //       this.workspaces.set(workspaces);
  //       if (workspaces.length > 0) {
  //         this.selectWorkspace(workspaces[0]);
  //       }
  //       this.isLoading.set(false);
  //     },
  //     error: (err) => {
  //       this.error.set('Failed to load workspaces. Please try again.');
  //       this.isLoading.set(false);
  //       console.error('Error fetching workspaces:', err);
  //     }
  //   });
  // }

  // workspaces = signal<Workspace[]>([
  //   {
  //     id: 1,
  //     name: 'Co-Working',
  //     location: 'Road 9-Maadi-Cairo',
  //     createdAt: '2020-02-20',
  //     rating: 4.92,
  //     reviews: 116,
  //     image: './assets/Images/my workspaces01.png',
  //     rooms: [
  //       { id: 101, name: 'Room 01', image: './assets/Images/room01.png' },
  //       { id: 102, name: 'Room 02', image: './assets/Images/room02.png' }
  //     ]
  //   },
  //   {
  //     id: 2,
  //     name: 'Open Office',
  //     location: 'New Cairo - 90th Street',
  //     createdAt: '2021-05-10',
  //     rating: 4.75,
  //     reviews: 89,
  //     image: './assets/Images/my workspaces02.png',
  //     rooms: [
  //       { id: 201, name: 'Office A', image: './assets/Images/room01.png' },
  //       { id: 202, name: 'Office B', image: './assets/Images/room01.png' }
  //     ]
  //   }
  // ]);

  // selectedWorkspace = signal<IWorkspace>(this.workspaces()[0]);

  // selectWorkspace(workspace: IWorkspace): void {
  //   this.selectedWorkspace.set(workspace);
  // }
    fetchWorkspaces(): void {
    this.isLoading.set(true);
    this.error.set(null);

    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;

    if (!staffId) {
      this.error.set('User not authenticated');
      this.isLoading.set(false);
      return;
    }

    // Use the real staffId from the logged-in user
    this.workspaceService.getWorkspacesByStaff(/*staffId*/"stf001").subscribe({
      next: (workspaces) => {
        this.workspaces.set(workspaces);
        if (workspaces.length > 0) {
          this.selectWorkspace(workspaces[0]);
        }
        this.isLoading.set(false);
      },
      error: (err) => {
        this.error.set('Failed to load workspaces. Please try again.');
        this.isLoading.set(false);
        console.error('Error fetching workspaces:', err);
      }
    });
  }

  selectWorkspace(workspace: IWorkspace): void {
    this.selectedWorkspace.set(workspace);

    // Fetch rooms for the selected workspace
    this.workspaceService.getRoomsByWorkspace(workspace.id).subscribe({
      next: (rooms) => {
        this.selectedWorkspaceRooms.set(rooms || []);
      },
      error: (err) => {
        console.error('Error fetching rooms:', err);
        this.selectedWorkspaceRooms.set([]);
      }
    });

    // Fetch reviews for the selected workspace
    // this.workspaceService.getWorkspaceReviews(workspace.id).subscribe({
    //   next: (reviews) => {
    //     this.selectedWorkspaceReviews.set(reviews);
    //   },
    //   error: (err) => {
    //     console.error('Error fetching reviews:', err);
    //     this.selectedWorkspaceReviews.set([]);
    //   }
    // });
  }



  // navigateToOffers(workspaceId: string): void {
  //   this.router.navigate(['/offers', workspaceId]);
  // }
  goToOffers(workspaceId: string): void {
    this.router.navigate(['/offers', workspaceId]);
  }

  goToRecommendedFees(workspaceId: string): void {
    this.router.navigate(['/rooms-fees'], {
      queryParams: { workspaceId: workspaceId }
    });
  }
 onAddOffer(): void {
    if (this.offerForm.valid && this.selectedWorkspace()) {
      const offer = {
        id: `offer-${Date.now()}`,
        title: this.offerForm.value.title,
        description: this.offerForm.value.title,
        discountPercentage: parseInt(this.offerForm.value.percentage, 10),
        startDate: `${this.offerForm.value.dateFrom}T${this.offerForm.value.timeFrom}:00`,
        endDate: `${this.offerForm.value.dateTo}T${this.offerForm.value.timeTo}:00`,
        applicableRoomTypes: [],
        workspaceId: this.selectedWorkspace()!.id
      };
      console.log('New Offer:', offer);
      this.offerForm.reset();
      document.getElementById('addOfferModal')?.classList.remove('show');
      document.body.classList.remove('modal-open');
      document.querySelector('.modal-backdrop')?.remove();
    }
  }
}
