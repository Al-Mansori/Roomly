import { RoomService } from './../../core/services/room/room.service';
import { Component } from '@angular/core';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { IWorkspace } from '../../interfaces/iworkspace';
import { IRecommendation, IRecommendationResponse } from '../../interfaces/irecommendation';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";

@Component({
  selector: 'app-new-rooms',
  standalone: true,
  imports: [SideNavbarComponent],
  templateUrl: './new-rooms.component.html',
  styleUrl: './new-rooms.component.scss'
})
export class NewRoomsComponent {
  workspaces: IWorkspace[] = [];
  recommendations: IRecommendation[] = [];
  selectedWorkspaceId: string | null = null;
  isLoading = false;
  error: string | null = null;

  constructor(
    private workspaceService: WorkspaceService,
    private roomService: RoomService
  ) {}

  ngOnInit(): void {
    this.loadStaffIdAndWorkspaces();
  }
  loadStaffIdAndWorkspaces(): void {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id || null;
    if (!staffId) {
      this.error = 'User not authenticated';
      console.error(this.error);
      return;
    }

    this.isLoading = true;
    this.workspaceService.getWorkspacesByStaff(staffId).subscribe({
      next: (workspaces) => {
        this.workspaces = workspaces;
        if (workspaces.length > 0) {
          this.selectedWorkspaceId = workspaces[0].id; // Default to first workspace
          this.fetchRecommendations();
        }
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Failed to load workspaces. Please try again.';
        this.isLoading = false;
        console.error('Error fetching workspaces:', err);
      }
    });
  }

  fetchRecommendations(): void {
    if (!this.selectedWorkspaceId) {
      this.error = 'No workspace selected';
      return;
    }

    this.isLoading = true;
    this.roomService.getRecommendations(this.selectedWorkspaceId).subscribe({
      next: (response: IRecommendationResponse) => {
        this.recommendations = response.data.recommendations;
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Failed to load recommendations. Please try again.';
        this.isLoading = false;
        console.error('Error fetching recommendations:', err);
      }
    });
  }

  onWorkspaceChange(event: Event): void {
    this.selectedWorkspaceId = (event.target as HTMLSelectElement).value;
    this.fetchRecommendations();
  }

}
