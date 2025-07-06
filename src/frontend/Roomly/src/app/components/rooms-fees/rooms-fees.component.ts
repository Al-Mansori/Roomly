import { WorkspaceService } from './../../core/services/workspace/workspace.service';
import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { catchError, forkJoin, of, Subscription } from 'rxjs';
import { FeesService } from '../../core/services/fees/fees.service';
import { ActivatedRoute } from '@angular/router';
import { RoomService } from '../../core/services/room/room.service';
import { IFeesRecommendations } from '../../interfaces/i-fees-recommendations';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { IRoom } from '../../interfaces/iworkspace';
import { CommonModule } from '@angular/common';


interface Room {
  name: string;
  image: string;
  type: string;
  price: string;
  completionRate: string;
  cancellationRate: string;
  recommendedFee: string;
}

@Component({
  selector: 'app-rooms-fees',
  standalone: true,
  imports: [SideNavbarComponent, NgxSkeletonLoaderModule, CommonModule],
  templateUrl: './rooms-fees.component.html',
  styleUrl: './rooms-fees.component.scss'
})
export class RoomsFeesComponent {

  recommendations: IFeesRecommendations[] = [];
  filteredRecommendations: IFeesRecommendations[] = [];
  searchTerm: string = '';
  isLoading = false;
  errorMessage: string | null = null;
  private subscriptions: Subscription = new Subscription();
  private roomImageMap: Map<string, string> = new Map();

  constructor(
    private feesService: FeesService,
    private route: ActivatedRoute,
    private workspaceService: WorkspaceService,
    private roomService: RoomService
  ) { }

  ngOnInit(): void {
    this.subscriptions.add(
      this.route.queryParams.subscribe(params => {
        const workspaceId = params['workspaceId'];
        if (workspaceId) {
          this.loadCancellationFees(workspaceId);
        } else {
          this.errorMessage = 'No workspace ID provided.';
        }
      })
    );
  }

  ngOnDestroy(): void {
    this.subscriptions.unsubscribe();
  }

  onSearch(event: Event): void {
    this.searchTerm = (event.target as HTMLInputElement).value.toLowerCase();
    this.applySearch();
  }

  private applySearch(): void {
    this.filteredRecommendations = this.recommendations.filter(rec =>
      rec.room_name.toLowerCase().includes(this.searchTerm) ||
      rec.room_type.toLowerCase().includes(this.searchTerm) ||
      `$${rec.PricePerHour.toFixed(2)}/hour`.toLowerCase().includes(this.searchTerm)
    );
  }

  private loadCancellationFees(workspaceId: string): void {
    this.isLoading = true;
    this.errorMessage = null;
    this.subscriptions.add(
      this.feesService.getCancellationFees(workspaceId).subscribe({
        next: (response) => {
          this.recommendations = response.data.recommendations;
          this.workspaceService.getRoomsByWorkspace(workspaceId).subscribe({
            next: (roomsResponse) => {
              // Handle non-unique room names by mapping room_name to all matching room IDs
              const imageRequests = [];
              for (const rec of this.recommendations) {
                const matchingRooms = roomsResponse.filter(room => room.name === rec.room_name);
                if (matchingRooms.length > 0) {
                  // Use the first matching room's ID (can be adjusted if needed)
                  imageRequests.push(
                    this.roomService.getRoomById(matchingRooms[0].id).pipe(
                      catchError(() =>
                        of({
                          id: matchingRooms[0].id,
                          name: matchingRooms[0].name,
                          roomImages: null,
                          imageUrls: [],
                          type: matchingRooms[0].type,
                          description: matchingRooms[0].description,
                          capacity: matchingRooms[0].capacity,
                          availableCount: matchingRooms[0].availableCount,
                          pricePerHour: matchingRooms[0].pricePerHour,
                          status: matchingRooms[0].status,
                          amenities: matchingRooms[0].amenities,
                          offers: matchingRooms[0].offers
                        } as IRoom)
                      )
                    )
                  );
                }
              }
              forkJoin(imageRequests).subscribe({
                next: (roomDetails) => {
                  this.roomImageMap = new Map<string, string>();
                  let detailIndex = 0;
                  for (const rec of this.recommendations) {
                    const matchingRooms = roomsResponse.filter(room => room.name === rec.room_name);
                    if (matchingRooms.length > 0) {
                      const detail = roomDetails[detailIndex];
                      const imageUrl = detail.roomImages && detail.roomImages.length > 0
                        ? detail.roomImages[0].imageUrl
                        : 'https://via.placeholder.com/40';
                      this.roomImageMap.set(rec.room_name, imageUrl);
                      detailIndex++;
                    } else {
                      this.roomImageMap.set(rec.room_name, 'https://via.placeholder.com/40');
                    }
                  }
                  this.applySearch();
                  this.isLoading = false;
                },
                error: () => {
                  // Fallback to default image
                  this.roomImageMap = new Map<string, string>();
                  this.recommendations.forEach(rec => {
                    this.roomImageMap.set(rec.room_name, 'https://via.placeholder.com/40');
                  });
                  this.applySearch();
                  this.isLoading = false;
                }
              });
            },
            error: () => {
              // Fallback to default image
              this.roomImageMap = new Map<string, string>();
              this.recommendations.forEach(rec => {
                this.roomImageMap.set(rec.room_name, 'https://via.placeholder.com/40');
              });
              this.applySearch();
              this.isLoading = false;
            }
          });
        },
        error: (err) => {
          this.errorMessage = err.message;
          this.isLoading = false;
        }
      })
    );
  }

  getRoomImage(roomName: string): string {
    return this.roomImageMap.get(roomName) || 'https://via.placeholder.com/40';
  }
}
