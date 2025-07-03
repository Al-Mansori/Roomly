import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { IOffer } from '../../../interfaces/iworkspace';
import { catchError, Observable, tap, throwError } from 'rxjs';
import { v4 as uuidv4 } from 'uuid';

@Injectable({
  providedIn: 'root'
})
export class RoomService {


  constructor(private http: HttpClient) { }
  // addOffer(staffId: string, roomId: string, offer: IOffer): Observable<any> {
  //   const url = `/api/staff/offer?staffId=${staffId}&roomId=${roomId}`;
  //   console.log('Making offer request to:', url);

  //   return this.http.post(url, offer)
  //   .pipe(
  //     tap({
  //       next: (response) => console.log('Offer success:', response),
  //       error: (error) => {
  //         console.error('Full offer error:', {
  //           status: error.status,
  //           message: error.message,
  //           url: error.url,
  //           headers: error.headers,
  //           error: error.error
  //         });
  //       }
  //     }),
  //     catchError(error => {
  //       return throwError(() => new Error('Failed to add offer. Please check your permissions.'));
  //     })
  //   );
  // }

  // addOffer(staffId: string, roomId: string, offer: IOffer): Observable<any> {
  //   const url = `/api/staff/offer?staffId=${staffId}&roomId=${roomId}`;
  //   console.log('Making offer request to:', url);

  //   const offerWithId = {
  //     ...offer,
  //     id: uuidv4()
  //   };
  //   console.log('Request payload:', offerWithId);

  //   // Custom headers to handle CORS preflight
  //   const headers = new HttpHeaders({
  //     'Authorization': `Bearer ${localStorage.getItem('token') || sessionStorage.getItem('token')}`,
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'X-Requested-With': 'XMLHttpRequest' // Helps some servers identify AJAX requests
  //   });

  //   return this.http.post(url, offerWithId, { headers, observe: 'response' }).pipe(
  //     tap({
  //       next: (response: HttpResponse<any>) => {
  //         console.log('Offer success:', response);
  //         console.log('Response headers:', response.headers);
  //       },
  //       error: (error) => {
  //         console.error('Full offer error:', {
  //           status: error.status,
  //           message: error.message,
  //           url: error.url,
  //           headers: error.headers,
  //           error: error.error,
  //           responseText: error.error?.text || 'No response text'
  //         });
  //       }
  //     }),
  //     catchError(error => {
  //       console.error('Caught error:', error);
  //       return throwError(() => new Error('Failed to add offer. Please check your permissions or contact the backend team.'));
  //     })
  //   );
  // }

  
}
