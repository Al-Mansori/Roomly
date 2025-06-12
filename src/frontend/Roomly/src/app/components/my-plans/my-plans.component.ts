import { Component } from '@angular/core';
import { SideNavbarComponent } from "../side-navbar/side-navbar.component";

@Component({
  selector: 'app-my-plans',
  standalone: true,
  imports: [SideNavbarComponent],
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


}
