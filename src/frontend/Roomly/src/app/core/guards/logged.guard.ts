import { isPlatformBrowser } from '@angular/common';
import { inject, Inject, PLATFORM_ID } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';

export const loggedGuard: CanActivateFn = (route, state) => {
    const router = inject(Router);
    const platformId = inject(PLATFORM_ID);

    if (isPlatformBrowser(platformId)) {
        const token = localStorage.getItem('token') || sessionStorage.getItem('token');
        if (token) {
            router.navigate(['/dashboard']);
            return false;
        }
        return true;
    }
    return false;
};
