import { CommonModule } from '@angular/common';
import { Component, EventEmitter, Output } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-add-plan',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './add-plan.component.html',
  styleUrl: './add-plan.component.scss'
})
export class AddPlanComponent {

  // plan = {
  //   title: '',
  //   price: '',
  //   billing: 'monthly',
  //   allowedFeatures: [] as string[],
  //   deniedFeatures: [] as string[]
  // };

  // newAllowedFeature = '';
  // newDeniedFeature = '';

  // addAllowed() {
  //   if (this.newAllowedFeature.trim()) {
  //     this.plan.allowedFeatures.push(this.newAllowedFeature.trim());
  //     this.newAllowedFeature = '';
  //   }
  // }

  // removeAllowed(index: number) {
  //   this.plan.allowedFeatures.splice(index, 1);
  // }

  // editAllowed(index: number) {
  //   this.newAllowedFeature = this.plan.allowedFeatures[index];
  //   this.removeAllowed(index);
  // }

  // addDenied() {
  //   if (this.newDeniedFeature.trim()) {
  //     this.plan.deniedFeatures.push(this.newDeniedFeature.trim());
  //     this.newDeniedFeature = '';
  //   }
  // }

  // removeDenied(index: number) {
  //   this.plan.deniedFeatures.splice(index, 1);
  // }

  // editDenied(index: number) {
  //   this.newDeniedFeature = this.plan.deniedFeatures[index];
  //   this.removeDenied(index);
  // }

  // closeModal() {
  //   // handle close logic or emit event
  // }

  // savePlan() {
  //   // send this.plan to the parent or backend
  // }
  @Output() close = new EventEmitter();
  @Output() save = new EventEmitter();

  title = '';
  price = '';
  cycle = 'Monthly';
  allowedInput = '';
  deniedInput = '';
  allowedFeatures: string[] = [];
  deniedFeatures: string[] = [];

  addAllowedFeature() {
    if (this.allowedInput.trim()) {
      this.allowedFeatures.push(this.allowedInput.trim());
      this.allowedInput = '';
    }
  }

  addDeniedFeature() {
    if (this.deniedInput.trim()) {
      this.deniedFeatures.push(this.deniedInput.trim());
      this.deniedInput = '';
    }
  }

  removeAllowed(i: number) {
    this.allowedFeatures.splice(i, 1);
  }

  removeDenied(i: number) {
    this.deniedFeatures.splice(i, 1);
  }

  savePlan() {
    const newPlan = {
      title: this.title,
      price: Number(this.price),
      cycle: this.cycle,
      allowedFeatures: [...this.allowedFeatures],
      deniedFeatures: [...this.deniedFeatures],
      description: 'Auto-generated description based on features.'
    };
    this.save.emit(newPlan);
  }

  cancel() {
    this.close.emit();
  }

}
