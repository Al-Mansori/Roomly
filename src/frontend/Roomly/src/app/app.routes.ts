import { Routes } from '@angular/router';
import { BlankLayoutComponent } from './layouts/blank-layout/blank-layout.component';
// import { AuthLayoutComponent } from './layouts/auth-layout/auth-layout.component';
// import { authGuard } from './core/guards/auth.guard';
// import { loggedGuard } from './core/guards/logged.guard';

export const routes: Routes = [
  // 🔒 Auth routes (Temporarily disabled)
  /*
  {
    path: '',
    component: AuthLayoutComponent,
    canActivate: [loggedGuard],
    children: [
      { path: '', redirectTo: 'login', pathMatch: 'full' },
      {
        path: 'login',
        loadComponent: () =>
          import('./components/login/login.component').then((m) => m.LoginComponent)
      },
      {
        path: 'register',
        loadComponent: () =>
          import('./components/register/register.component').then((m) => m.RegisterComponent)
      }
    ]
  },
  */

  // ✅ Main app routes (default is now "offers/all")
  {
    path: '',
    component: BlankLayoutComponent,
    // canActivate: [authGuard], // ⛔ optional: disable during development
    children: [
      { path: '', redirectTo: 'my-plans', pathMatch: 'full' },

      {
        path: 'offers',
        loadComponent: () =>
          import('./components/offers/all-offers-list/all-offers-list.component').then((m) => m.AllOffersListComponent),
        children: [
          { path: '', redirectTo: 'all', pathMatch: 'full' },
          {
            path: 'all',
            loadComponent: () =>
              import('./components/offers/offers-all/offers-all.component').then((m) => m.OffersAllComponent)
          },
          {
            path: 'present',
            loadComponent: () =>
              import('./components/offers/offers-present/offers-present.component').then((m) => m.OffersPresentComponent)
          },
          {
            path: 'expired',
            loadComponent: () =>
              import('./components/offers/offers-expired/offers-expired.component').then((m) => m.OffersExpiredComponent)
          }
        ]
      },

      {
        path: 'dashboard',
        loadComponent: () =>
          import('./components/dashboard/dashboard.component').then((m) => m.DashboardComponent)
      },
      {
        path: 'profile',
        loadComponent: () =>
          import('./components/profile/profile.component').then((m) => m.ProfileComponent)
      },
      {
        path: 'my-workspaces', loadComponent: () => import('./components/my-workspaces/my-workspaces.component').then((m) => m.MyWorkspacesComponent)
      },
      {
        path: 'rooms-fees', loadComponent: () => import('./components/rooms-fees/rooms-fees.component').then((m) => m.RoomsFeesComponent)
      },
      {
        path: 'support', loadComponent: () => import('./components/support/support.component').then((m) => m.SupportComponent)
          
      },
            {
        path: 'my-plans', loadComponent: () => import('./components/my-plans/my-plans.component').then((m) => m.MyPlansComponent)
          
      },
    ]
  },

  // Optional: catch-all route
  /*
  {
    path: '**',
    loadComponent: () =>
      import('./components/not-found/not-found.component').then((m) => m.NotFoundComponent)
  }
  */
];
