import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';
import { IReservation } from '../../../interfaces/ireservation';
import { IRequest } from '../../../interfaces/irequest';

@Injectable({
  providedIn: 'root'
})
export class ReservationService {

  constructor(private http: HttpClient) { }

  getReservationsByStaff(staffId: string): Observable<IReservation[]> {
    const url = `/api/staff/reservations?staffId=${staffId}`;
    return this.http.get<IReservation[]>(url).pipe(
      catchError(error => {
        console.error('Error fetching reservations:', error);
        return throwError(() => new Error('Failed to fetch reservations'));
      })
    );
  }

  getReservationsByWorkspace(workspaceId: string): Observable<IReservation[]> {
    const url = `/api/staff/reservations/workspace/${workspaceId}`;
    return this.http.get<IReservation[]>(url).pipe(
      catchError(error => {
        console.error('Error fetching workspace reservations:', error);
        return throwError(() => new Error('Failed to fetch workspace reservations'));
      })
    );
  }

  getRequestsByStaff(staffId: string): Observable<IRequest[]> {
    const url = `/api/staff/requests?staffId=${staffId}`;
    return this.http.get<IRequest[]>(url).pipe(
      catchError(error => {
        console.error('Error fetching requests:', error);
        return throwError(() => new Error('Failed to fetch requests'));
      })
    );
  }

  // Placeholder for approval/rejection (implement backend endpoints)
  approveRequest(requestId: string): Observable<any> {
    const url = `/api/staff/request/approve?requestId=${requestId}`; // Updated to PUT and correct URL
    return this.http.put(url, {}).pipe(
      catchError(error => {
        console.error('Error approving request:', error);
        return throwError(() => new Error('Failed to approve request'));
      })
    );
  }

  rejectRequest(requestId: string): Observable<any> {
    const url = `/api/staff/request/reject?requestId=${requestId}`; // Updated to PUT and correct URL
    return this.http.put(url, {}).pipe(
      catchError(error => {
        console.error('Error rejecting request:', error);
        return throwError(() => new Error('Failed to reject request'));
      })
    );
  }

  createReservation(
    startTime: string,
    endTime: string,
    amenitiesCount: number,
    workspaceId: string,
    roomId: string
  ): Observable<any> {
    const url = `/api/staff/reserve?paymentMethod=CASH&amenitiesCount=${amenitiesCount}&startTime=${startTime}&endTime=${endTime}&reservationType=HOURLY&workspaceId=${workspaceId}&roomId=${roomId}`;
    return this.http.post(url, {}).pipe(
      catchError(error => {
        console.error('Error creating reservation:', error);
        return throwError(() => new Error('Failed to create reservation'));
      })
    );
  }
}
