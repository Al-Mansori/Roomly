import { CanActivateFn } from '@angular/router';

export const hGuard: CanActivateFn = (route, state) => {
  return true;
};
