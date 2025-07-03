import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { provideRouter, withInMemoryScrolling, withViewTransitions } from '@angular/router';

import { routes } from './app.routes';
<<<<<<< HEAD
import { BrowserModule, provideClientHydration } from '@angular/platform-browser';
import { provideHttpClient, withFetch, withInterceptors, withInterceptorsFromDi } from '@angular/common/http';
import { provideToastr } from 'ngx-toastr';
import { provideAnimations } from '@angular/platform-browser/animations';
import { NgxSpinnerModule } from 'ngx-spinner';
import { loadingInterceptor } from './core/interceptor/loading-interceptor';
import { GoogleMap, GoogleMapsModule  } from '@angular/google-maps'; // ✅

export const appConfig: ApplicationConfig = {
  providers: [
    provideToastr(),
    provideAnimations(),
    importProvidersFrom(NgxSpinnerModule),
    provideRouter(routes, withViewTransitions(), withInMemoryScrolling({ scrollPositionRestoration: 'top' })),
    provideClientHydration(),
    provideHttpClient(withFetch(), withInterceptors([loadingInterceptor]) ,withInterceptorsFromDi()),
    
    importProvidersFrom(GoogleMapsModule , BrowserModule), // ✅ أضف دي هنا

=======
import { provideHttpClient, withFetch, withInterceptors } from '@angular/common/http';
import { headerInterceptor } from './core/interceptor/header/header.interceptor';

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(withInterceptors([headerInterceptor]), withFetch()),
    provideRouter(routes, withViewTransitions()),
    // provideHttpClient(withFetch()) // ✅ Enable fetch mode (SSR-safe)
>>>>>>> 9d890f7d568efeec9b3f76b0f6af0208c8729ee7
  ]
};
