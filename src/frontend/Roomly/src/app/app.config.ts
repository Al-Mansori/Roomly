import { ApplicationConfig } from '@angular/core';
import { provideRouter, withViewTransitions } from '@angular/router';

import { routes } from './app.routes';
import { provideHttpClient, withFetch, withInterceptors } from '@angular/common/http';
import { headerInterceptor } from './core/interceptor/header/header.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(withInterceptors([headerInterceptor]), withFetch()),
    provideRouter(routes, withViewTransitions()),
    // provideHttpClient(withFetch()) // ✅ Enable fetch mode (SSR-safe)
  ]
};
