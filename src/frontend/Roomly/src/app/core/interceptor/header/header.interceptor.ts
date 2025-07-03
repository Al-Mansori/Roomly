// // header.interceptor.ts
import { HttpInterceptorFn } from '@angular/common/http';

export const headerInterceptor: HttpInterceptorFn = (req, next) => {
  // Skip if not in browser environment
  if (typeof window === 'undefined') return next(req);

  // Skip login endpoint
  if (req.url.includes('/api/users/auth/login')) {
    console.log('Skipping auth headers for login request:', req.url);
    return next(req);
  }

  const token = localStorage.getItem('token') || sessionStorage.getItem('token');

  // Check if this is an API request
  const isApiRequest = req.url.startsWith('/api');

  // Clone request and add headers if needed
  if (token && isApiRequest) {
    const authReq = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Requested-With': 'XMLHttpRequest'
      }
    });
    console.log('Intercepted request with auth headers:', authReq.url);
    console.log('Request Details:', authReq.url, authReq.headers.get('Authorization'));
    console.log('Token used:', token);
    return next(authReq);
  }

  console.log('Request without auth headers:', req.url); // Changed to log URL for clarity
  return next(req);
};