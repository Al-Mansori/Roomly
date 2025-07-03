import { ApplicationConfig, importProvidersFrom } from '@angular/core';
import { provideRouter, withInMemoryScrolling, withViewTransitions } from '@angular/router';

import { routes } from './app.routes';
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

  ]
};
