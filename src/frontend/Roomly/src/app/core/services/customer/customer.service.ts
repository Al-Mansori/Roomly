import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';
import { ICustomer } from '../../../interfaces/icustomer';

@Injectable({
  providedIn: 'root'
})
export class CustomerService {

  constructor(private http: HttpClient) {}

  // getUsersByStaff(staffId: string): Observable<ICustomer[]> {
  //   const url = `/api/staff/users-list?staffId=${staffId}`;
  //   return this.http.get<ICustomer[]>(url).pipe(
  //     catchError(error => {
  //       console.error('Error fetching users:', error);
  //       return throwError(() => new Error('Failed to fetch users'));
  //     })
  //   );
  // }

  // getBlockedUsers(staffId: string): Observable<string[]> {
  //   const url = `/api/staff/blocked/users?staffId=${staffId}`;
  //   return this.http.get<string[]>(url).pipe(
  //     catchError(error => {
  //       console.error('Error fetching blocked users:', error);
  //       return throwError(() => new Error('Failed to fetch blocked users'));
  //     })
  //   );
  // }

  // // https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/block/user?staffId=stf001&userId=usr003
  // blockUser(staffId: string, userId: string): Observable<string> {
  //   const url = `/api/staff/block/user?staffId=${staffId}&userId=${userId}`;
  //   return this.http.post(url, {}, { responseType: 'text' }).pipe(
  //     catchError(error => {
  //       console.error('Error blocking user:', error);
  //       return throwError(() => new Error('Failed to block user'));
  //     })
  //   );
  // }

  // unblockUser(staffId: string, userId: string): Observable<string> {
  //   const url = `/api/staff/unblock/user?staffId=${staffId}&userId=${userId}`;
  //   return this.http.post(url, {}, { responseType: 'text' }).pipe(
  //     catchError(error => {
  //       console.error('Error unblocking user:', error);
  //       return throwError(() => new Error('Failed to unblock user'));
  //     })
  //   );
  // }

  getUsersByStaff(staffId: string): Observable<ICustomer[]> {
    const url = `/api/staff/users-list?staffId=${staffId}`;
    return this.http.get<ICustomer[]>(url).pipe(
      catchError(error => {
        console.error('Error fetching users:', error);
        return throwError(() => new Error('Failed to fetch users'));
      })
    );
  }

  getBlockedUsers(staffId: string): Observable<string[]> {
    const url = `/api/staff/blocked/users?staffId=${staffId}`;
    return this.http.get<string[]>(url).pipe(
      catchError(error => {
        console.error('Error fetching blocked users:', error);
        return throwError(() => new Error('Failed to fetch blocked users'));
      })
    );
  }

  blockUser(staffId: string, userId: string): Observable<string> {
    const url = `/api/staff/block/user?staffId=${staffId}&userId=${userId}`;
    return this.http.post(url, {}, { responseType: 'text' }).pipe(
      catchError(error => {
        console.error('Error blocking user:', error);
      return throwError(() => new Error('Failed to block user'));
      })
    );
  }

  unblockUser(staffId: string, userId: string): Observable<string> {
    const url = `/api/staff/unblock/user?staffId=${staffId}&userId=${userId}`;
    return this.http.post(url, {}, { responseType: 'text' }).pipe(
      catchError(error => {
        console.error('Error unblocking user:', error);
        return throwError(() => new Error('Failed to unblock user'));
      })
    );
  }
}
