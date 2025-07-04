import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, firstValueFrom, map, Observable, throwError } from 'rxjs';
import { IReservation } from '../../../interfaces/ireservation';
import { IRequest } from '../../../interfaces/irequest';
import { environment } from '../../environment/environments';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root'
})
export class ReservationService {
  private baseUrl = environment.baseUrl;

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
  approveRequest(requestId: string): Observable<string> {
    const url = `/api/staff/request/approve?requestId=${requestId}`;
    return this.http.put(url, {}, { responseType: 'text' }).pipe(
      catchError(error => {
        console.error('Error approving request:', error);
        return throwError(() => new Error(error.error || 'Failed to approve request'));
      })
    );
  }

  rejectRequest(requestId: string): Observable<string> {
    const url = `/api/staff/request/reject?requestId=${requestId}`;
    return this.http.put(url, {}, { responseType: 'text' }).pipe(
      catchError(error => {
        console.error('Error rejecting request:', error);
        return throwError(() => new Error(error.error || 'Failed to reject request'));
      })
    );
  }
  // createReservation(
  //   startTime: string,
  //   endTime: string,
  //   amenitiesCount: number,
  //   workspaceId: string,
  //   roomId: string
  // ): Observable<any> {
  //   const url = `/api/staff/reserve?paymentMethod=CASH&amenitiesCount=${amenitiesCount}&startTime=${startTime}&endTime=${endTime}&reservationType=HOURLY&workspaceId=${workspaceId}&roomId=${roomId}`;
  //   return this.http.post(url, {}).pipe(
  //     catchError(error => {
  //       console.error('Error creating reservation:', error);
  //       return throwError(() => new Error('Failed to create reservation'));
  //     })
  //   );
  // }
  createReservation(
    startTime: string,
    endTime: string,
    amenitiesCount: number,
    workspaceId: string,
    roomId: string,
    reservationType: string
  ): Observable<any> {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    const userId = user?.id;

    if (!userId) {
      throw new Error('User ID is required and not found in storage');
    }
    // Ensure dates include seconds in the format YYYY-MM-DDTHH:mm:ss
    const formattedStartTime = `${startTime}:00`; // Append :00 for seconds
    const formattedEndTime = `${endTime}:00`;    // Append :00 for seconds

    const url = `/api/staff/reserve?paymentMethod=CASH&amenitiesCount=${amenitiesCount}&startTime=${formattedStartTime}&endTime=${formattedEndTime}&reservationType=${reservationType}&userId=${userId}&workspaceId=${workspaceId}&roomId=${roomId}`;
    return this.http.post(url, {}).pipe(
      catchError(error => {
        console.error('Error creating reservation:', error);
        return throwError(() => new Error(error.error?.message || 'Failed to create reservation'));
      })
    );
  }


}
