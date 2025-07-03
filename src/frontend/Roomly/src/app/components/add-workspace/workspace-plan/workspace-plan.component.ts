import { Component, Output, EventEmitter, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-workspace-plan',
  standalone: true,
  imports: [FormsModule, CommonModule],
  templateUrl: './workspace-plan.component.html',
  styleUrls: ['./workspace-plan.component.scss']
})
export class WorkspacePlanComponent implements OnInit {
  @Output() planDataChanged = new EventEmitter<{
    paymentType: string;
    workspaceType: string;
  }>();

  selectedPaymentType: string = '';
  workspaceType: string = '';

  ngOnInit() {
    // إرسال البيانات الأولية عند تهيئة المكون
    this.emitPlanData();
  }

  // يتم استدعاؤها عند تغيير نوع الدفع
  onPaymentTypeChange() {
    console.log('Payment type changed to:', this.selectedPaymentType); // لأغراض debugging
    this.emitPlanData();
  }

  // يتم استدعاؤها عند تغيير نوع مساحة العمل
  onWorkspaceTypeChange(event: Event) {
    const input = event.target as HTMLInputElement;
    this.workspaceType = input.value;
    console.log('Workspace type changed to:', this.workspaceType); // لأغراض debugging
    this.emitPlanData();
  }

  // إرسال البيانات إلى المكون الأب
  private emitPlanData() {
    const data = {
      paymentType: this.selectedPaymentType,
      workspaceType: this.workspaceType
    };
    
    console.log('Emitting plan data:', data); // لأغراض debugging
    this.planDataChanged.emit(data);
  }
}

