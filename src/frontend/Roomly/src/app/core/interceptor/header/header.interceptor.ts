import { HttpInterceptorFn } from '@angular/common/http';

export const headerInterceptor: HttpInterceptorFn = (req, next) => {
  const token = localStorage.getItem('token') || sessionStorage.getItem('token');

  // Check if this is an API request
  const isApiRequest = req.url.startsWith('/api');

  // Clone request and add headers if needed
  if (token && isApiRequest) {
    const authReq = req.clone({
      setHeaders: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json'
      }
    });
    return next(authReq);
  }

  return next(req);
};
