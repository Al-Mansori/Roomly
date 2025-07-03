import { BlankLayoutComponent } from './layouts/blank-layout/blank-layout.component';
import { AuthLayoutComponent } from './layouts/auth-layout/auth-layout.component';
import { Routes } from '@angular/router';

export const routes: Routes = [
  // 🔒 Auth routes (Temporarily disabled)

  // 🌐 Public Routes (not logged in)
 {
  path: '',
  component: AuthLayoutComponent,
  // canActivate: [logoutGuard], // ✅ ضيفي دا هنا
  children: [
    { path: '', redirectTo: 'home', pathMatch: 'full' },
    {
      path: 'home',
      loadComponent: () =>
        import('./components/home/home.component').then((m) => m.HomeComponent)
    },
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


  {
    path: '',
    component: BlankLayoutComponent,
    // canActivate: [authenticationGGuard], // ✅ ضيفي دا هنا
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      // offers
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
        path: 'add-workspace',
        loadComponent: () => import('./components/add-workspace/add-workspace.component').then(m => m.AddWorkspaceComponent)
      },
      {
        path: 'add-rooms',
        loadComponent: () => 
          import('./components/add-rooms/add-rooms.component').then(m => m.AddRoomsComponent),
        data: {
          title: 'Add room'
        }
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
            {
        path: 'bookings',
        loadComponent: () => import('./components/bookings/bookings-list/bookings-list.component').then(m => m.BookingsListComponent),
        children: [
          { path: '', redirectTo: 'all', pathMatch: 'full' },
          {
            path: 'all',
            loadComponent: () => import('./components/bookings/all-bookings/all-bookings.component').then(m => m.AllBookingsComponent),
          },
          {
            path: 'requests',
            loadComponent: () => import('./components/bookings/requests/requests.component').then(m => m.RequestsComponent),
          },
          {
            path: 'upcoming',
            loadComponent: () => import('./components/bookings/upcoming-bookings/upcoming-bookings.component').then(m => m.UpcomingBookingsComponent),
          },
          {
            path: 'ongoing',
            loadComponent: () => import('./components/bookings/ongoing-bookings/ongoing-bookings.component').then(m => m.OngoingBookingsComponent),
          },
          {
            path: 'history',
            loadComponent: () => import('./components/bookings/history/history.component').then(m => m.HistoryComponent),
          }
        ]
      }
      // {
      //   path: 'bookings-list', loadComponent: () => import('./components/bookings/bookings-list/bookings-list.component').then((m) => m.BookingsListComponent)

      // },


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
