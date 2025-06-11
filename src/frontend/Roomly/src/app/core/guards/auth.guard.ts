// import { isPlatformBrowser } from '@angular/common';
// import { inject, PLATFORM_ID } from '@angular/core';
// import { CanActivateFn, Router } from '@angular/router';

// export const authGuard: CanActivateFn = (route, state) => {
//   const _Router = inject(Router);
//   const _PLATFORM_ID = inject(PLATFORM_ID);
//   //the route parameter holds all info of the current route
//   //the state parameter holds the path only

//   //check id we are in the broswer not in the server, cause the local storage is undefined in the server
//   //se we will run the code only in the browser to avoid any errors
//   if (isPlatformBrowser(_PLATFORM_ID)) {
//     if (localStorage.getItem('token')) {
//       return true;
//     }
//     else {
//       //navigate to login
//       _Router.navigate(['/login']);
//       return false;
//     }

//   }
//   //just to avoid errors cause the guard must have returned 
//   else{
//     return false;
//   }
// };
