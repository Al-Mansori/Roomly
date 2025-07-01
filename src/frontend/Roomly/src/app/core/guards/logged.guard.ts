// import { isPlatformBrowser } from '@angular/common';
// import { inject, Inject, PLATFORM_ID } from '@angular/core';
// import { CanActivateFn, Router } from '@angular/router';

// export const loggedGuard: CanActivateFn = (route, state) => {
//   const _Router = inject(Router);
//   const _PLATFORM_ID = inject(PLATFORM_ID);

//   if (isPlatformBrowser(_PLATFORM_ID)) {
//     //if the user already logged in we prevent him to navigate to the login page
//     if (localStorage.getItem('token') !== null) {
//       //navigate to home
//       _Router.navigate(['/home']);
//       return false;

//     }
//     else {
//       return true;
//     }
//   }
//   else {
//     return false;
//   }
// };
