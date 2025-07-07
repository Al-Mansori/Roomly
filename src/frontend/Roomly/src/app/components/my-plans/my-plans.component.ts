import { Component, OnInit } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import Swal from 'sweetalert2';
import { PlanService } from '../../core/services/plan/plan.service';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';

@Component({
  selector: 'app-my-plans',
  standalone: true,
  imports: [SideNavbarComponent, FormsModule, CommonModule],
  templateUrl: './my-plans.component.html',
  styleUrl: './my-plans.component.scss'
})
export class MyPlansComponent implements OnInit {
  plans: any[] = [];
  workspaces: any[] = [];
  selectedWorkspaceId: string | null = null;
  isLoading = false;

  // Modal Form Inputs (only prices are actually sent)
  newPlan = {
    dailyPrice: 0,
    monthPrice: 0,
    yearPrice: 0,
    // UI-only fields
    title: 'Workspace Plan',
    description: 'Custom pricing plan for this workspace',
    allowedFeatures: [
      'Access to workspace facilities',
      'Standard support',
      'Flexible hours'
    ],
    deniedFeatures: [] as string[]
  };

  // Input fields for features (UI only)
  allowedInput: string = '';
  deniedInput: string = '';
  allowedFeatures: string[] = [...this.newPlan.allowedFeatures];
  deniedFeatures: string[] = [];

  constructor(
    private planService: PlanService,
    private workspaceService: WorkspaceService
  ) {}

  ngOnInit() {
    this.fetchWorkspaces();
    this.fetchPlans();
  }

  fetchWorkspaces() {
    this.isLoading = true;
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const staffId = user?.id;
    
    if (!staffId) {
      Swal.fire('Error', 'User not authenticated', 'error');
      this.isLoading = false;
      return;
    }

    this.workspaceService.getWorkspacesByStaff(staffId).subscribe({
      next: (workspaces) => {
        this.workspaces = workspaces;
        if (workspaces.length > 0) {
          this.selectedWorkspaceId = workspaces[0].id;
          this.fetchWorkspaces();
        }
        this.isLoading = false;
      },
      error: (error) => {
        Swal.fire('Error', 'Failed to fetch workspaces', 'error');
        this.isLoading = false;
      }
    });
  }

  onWorkspaceChange() {
    if (this.selectedWorkspaceId) {
      this.fetchWorkspaces();
    }
  }
  
  private getStaffId(): string {
  const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
  return user?.id || '';
  }

  //   fetchPlansByStaff() {
  //   if (!this.selectedWorkspaceId) return;

  //   this.isLoading = true;
  //   this.planService.getPlanByStaff(this.getStaffId()).subscribe({
  //     next: (data: any) => {
  //       this.plans = [{
  //         id: 1, // Assuming single plan per workspace
  //         title: this.newPlan.title,
  //         description: this.newPlan.description,
  //         dailyPrice: data.dailyPrice || 0,
  //         monthPrice: data.monthPrice || 0,
  //         yearPrice: data.yearPrice || 0,
  //         allowedFeatures: this.allowedFeatures,
  //         deniedFeatures: this.deniedFeatures
  //       }];
  //       this.isLoading = false;
  //     },
  //     error: (error) => {
  //       Swal.fire('Error', 'Failed to fetch plans', 'error');
  //       this.isLoading = false;
  //     }
  //   });
  // }


fetchPlans() {
  if (!this.selectedWorkspaceId) return;

  this.isLoading = true;
  this.planService.getPlan(this.selectedWorkspaceId).subscribe({
    next: (data: any) => {
      console.log('Plan API Response:', data);  // DEBUGGING

      if (!data || Object.keys(data).length === 0) {
        Swal.fire('Info', 'No plan found for this workspace', 'info');
        this.plans = [];
        this.isLoading = false;
        return;
      }

      this.plans = [{
        id: data.id || 1,
        title: data.title || this.newPlan.title,
        description: data.description || this.newPlan.description,
        dailyPrice: data.dailyPrice ?? 0,
        monthPrice: data.monthPrice ?? 0,
        yearPrice: data.yearPrice ?? 0,
        allowedFeatures: data.allowedFeatures || [],
        deniedFeatures: data.deniedFeatures || []
      }];

      this.allowedFeatures = [...this.plans[0].allowedFeatures];
      this.deniedFeatures = [...this.plans[0].deniedFeatures];
      this.isLoading = false;
    },
    error: (error) => {
      console.error('Error fetching plan:', error);
      Swal.fire('Error', 'Failed to fetch plans', 'error');
      this.isLoading = false;
    }
  });
}

  // Add/remove features (UI only)
  addAllowedFeature() {
    const feature = this.allowedInput.trim();
    if (feature) {
      this.allowedFeatures.push(feature);
      this.allowedInput = '';
    }
  }

  removeAllowed(index: number) {
    this.allowedFeatures.splice(index, 1);
  }

  addDeniedFeature() {
    const feature = this.deniedInput.trim();
    if (feature) {
      this.deniedFeatures.push(feature);
      this.deniedInput = '';
    }
  }

  removeDenied(index: number) {
    this.deniedFeatures.splice(index, 1);
  }

  savePlan() {
    if (!this.selectedWorkspaceId) {
      Swal.fire('Warning', 'Please select a workspace first', 'warning');
      return;
    }

    // Only these fields are actually sent to the API
    const planData = {
      dailyPrice: this.newPlan.dailyPrice,
      monthPrice: this.newPlan.monthPrice,
      yearPrice: this.newPlan.yearPrice
    };

    this.isLoading = true;
    this.planService.updatePlan(planData , this.selectedWorkspaceId).subscribe({
      next: () => {
        Swal.fire('Success', 'Plan updated successfully!', 'success');
        this.fetchPlans();
        this.isLoading = false;
        document.getElementById('closeModal')?.click();
      },
      error: () => {
        Swal.fire('Error', 'Failed to update plan', 'error');
        this.isLoading = false;
      }
    });
  }

  resetForm() {
    this.newPlan = {
      dailyPrice: 0,
      monthPrice: 0,
      yearPrice: 0,
      title: 'Workspace Plan',
      description: 'Custom pricing plan for this workspace',
      allowedFeatures: [
        'Access to workspace facilities',
        'Standard support',
        'Flexible hours'
      ],
      deniedFeatures: []
    };
    this.allowedFeatures = [...this.newPlan.allowedFeatures];
    this.deniedFeatures = [];
    this.allowedInput = '';
    this.deniedInput = '';
  }
}