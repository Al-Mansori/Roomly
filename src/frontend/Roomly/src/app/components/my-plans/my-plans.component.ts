import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-my-plans',
  standalone: true,
  imports: [SideNavbarComponent, FormsModule, CommonModule],
  templateUrl: './my-plans.component.html',
  styleUrl: './my-plans.component.scss'
})
export class MyPlansComponent {
  plans = [
    {
      id: 1,
      title: 'Basic Plan',
      description: 'Access to one workspace with standard support and limited hours per week.',
      price: 299,
      allowedFeatures: [
        'Access to 1 workspace',
        'Standard support (Email only)',
        '20 hours/week usage limit'
      ],
      deniedFeatures: [
        'No guest passes',
        'No priority bookings'
      ]
    },
    {
      id: 2,
      title: 'Standard Plan',
      description: 'Perfect for regular users who need access to multiple rooms and extended hours.',
      price: 599,
      allowedFeatures: [
        'Access to 3 workspaces',
        'Priority email support',
        '60 hours/week usage limit',
        '2 guest passes per month',
        'Room booking priority'
      ],
      deniedFeatures: []
    },
    {
      id: 3,
      title: 'Premium Plan',
      description: 'Unlimited workspace access with premium support and exclusive perks.',
      price: 999,
      allowedFeatures: [
        'Unlimited workspace access',
        'Unlimited usage hours',
        'Unlimited guest passes',
        'Priority workspace reservations',
        'Access to private rooms & meeting spaces',
        'Dedicated account manager'
      ],
      deniedFeatures: []
    }
  ];

  // Modal Form Inputs
  newPlan = {
    id: 0,
    title: '',
    description: '',
    price: 0,
    billing: 'monthly',
    allowedFeatures: [] as string[],
    deniedFeatures: [] as string[]
  };

  // Input fields for features
  allowedInput: string = '';
  deniedInput: string = '';
  allowedFeatures: string[] = [];
  deniedFeatures: string[] = [];

  // Add Allowed Feature
  addAllowedFeature() {
    const feature = this.allowedInput.trim();
    if (feature) {
      this.allowedFeatures.push(feature);
      this.allowedInput = '';
    }
  }

  // Remove Allowed Feature
  removeAllowed(index: number) {
    this.allowedFeatures.splice(index, 1);
  }

  // Add Denied Feature
  addDeniedFeature() {
    const feature = this.deniedInput.trim();
    if (feature) {
      this.deniedFeatures.push(feature);
      this.deniedInput = '';
    }
  }

  // Remove Denied Feature
  removeDenied(index: number) {
    this.deniedFeatures.splice(index, 1);
  }

  // Save Plan
  savePlan() {
    if (!this.newPlan.title || !this.newPlan.price || !this.newPlan.description) return;

    const newId = Date.now();
    this.plans.push({
      ...this.newPlan,
      id: newId,
      price: Number(this.newPlan.price),
      allowedFeatures: [...this.allowedFeatures],
      deniedFeatures: [...this.deniedFeatures]
    });

    // Reset all fields
    this.newPlan = {
      id: 0,
      title: '',
      description: '',
      price: 0,
      billing: 'monthly',
      allowedFeatures: [],
      deniedFeatures: []
    };
    this.allowedInput = '';
    this.deniedInput = '';
    this.allowedFeatures = [];
    this.deniedFeatures = [];
  }
}