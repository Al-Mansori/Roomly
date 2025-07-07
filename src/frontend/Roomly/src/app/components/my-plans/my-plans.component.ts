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
  editingPlanId: number | null = null;

  // نموذج الخطة المبسط حسب متطلبات الـ API
  newPlan = {
    id: null as number | null,
    dailyPrice: 0,
    monthPrice: 0,
    yearPrice: 0
  };

  constructor(
    private planService: PlanService,
    private workspaceService: WorkspaceService
  ) {}

  ngOnInit() {
    this.fetchWorkspaces();
  }

  fetchWorkspaces() {
    this.isLoading = true;
    const staffId = this.getStaffId();
    
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
          this.fetchPlansByStaff();
        }
        this.isLoading = false;
      },
      error: (error) => {
        Swal.fire('Error', 'Failed to fetch workspaces', 'error');
        this.isLoading = false;
      }
    });
  }

fetchPlansByStaff() {
  const staffId = this.getStaffId();
  if (!staffId) return;

  this.isLoading = true;
  this.planService.getPlanByStaff(staffId).subscribe({
    next: (plansObj: any) => {
      console.log('Raw plans object:', plansObj);

      // جلب الخطة الخاصة بالـ workspace المختار
      const selectedPlan = plansObj[this.selectedWorkspaceId!];

      if (!selectedPlan) {
        this.plans = []; // لا توجد خطة
      } else {
        this.plans = [{
          ...selectedPlan,
          description: 'Custom pricing plan',
          allowedFeatures: [
            'Access to workspace facilities',
            'Standard support',
            'Flexible hours'
          ],
          deniedFeatures: []
        }];
      }

      this.isLoading = false;
    },
    error: (error) => {
      console.error('Error fetching plans:', error);
      Swal.fire('Error', 'Failed to fetch plans', 'error');
      this.isLoading = false;
    }
  });
}

  private getStaffId(): string {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    return user?.id || '';
  }
// أضف هذه الدالة إلى المكون
deletePlan(planId: number) {
  if (!this.selectedWorkspaceId) {
    Swal.fire('Warning', 'Please select a workspace first', 'warning');
    return;
  }

  Swal.fire({
    title: 'Are you sure?',
    text: 'You won\'t be able to revert this!',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, delete it!'
  }).then((result) => {
    if (result.isConfirmed) {
      this.isLoading = true;
      this.planService.deletePlan(this.selectedWorkspaceId!).subscribe({
        next: () => {
          Swal.fire('Deleted!', 'Your plan has been deleted.', 'success');
          this.fetchPlansByStaff(); // Refresh the plans list
          this.isLoading = false;
        },
        error: (error) => {
          console.error('Error deleting plan:', error);
          Swal.fire('Error', 'Failed to delete plan', 'error');
          this.isLoading = false;
        }
      });
    }
  });
}
  openAddPlanModal() {
    if (this.plans.length > 0) {
      Swal.fire('Notice', 'This workspace already has a plan.', 'info');
      return;
    }
    this.resetForm();
    this.editingPlanId = null;
  }


  editPlan(plan: any) {
    this.newPlan = {
      id: plan.id,
      dailyPrice: plan.dailyPrice,
      monthPrice: plan.monthPrice,
      yearPrice: plan.yearPrice
    };
    this.editingPlanId = plan.id;
  }

  savePlan() {
    if (!this.selectedWorkspaceId) {
      Swal.fire('Warning', 'Please select a workspace first', 'warning');
      return;
    }

    this.isLoading = true;
    
    // إرسال البيانات الأساسية فقط إلى API
    const planData = {
      dailyPrice: this.newPlan.dailyPrice,
      monthPrice: this.newPlan.monthPrice,
      yearPrice: this.newPlan.yearPrice
    };

    const observable = this.editingPlanId 
      ? this.planService.updatePlan(planData, this.selectedWorkspaceId)
      : this.planService.createPlan(planData, this.selectedWorkspaceId);

    observable.subscribe({
      next: () => {
        Swal.fire('Success', `Plan ${this.editingPlanId ? 'updated' : 'created'} successfully!`, 'success');
        this.fetchPlansByStaff();
        this.isLoading = false;
        document.getElementById('closeModal')?.click();
      },
      error: () => {
        Swal.fire('Error', `Failed to ${this.editingPlanId ? 'update' : 'create'} plan`, 'error');
        this.isLoading = false;
      }
    });
  }

  resetForm() {
    this.newPlan = {
      id: null,
      dailyPrice: 0,
      monthPrice: 0,
      yearPrice: 0
    };
  }
}