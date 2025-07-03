import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { IOffer } from '../../../interfaces/iworkspace';
import { catchError, Observable, tap, throwError } from 'rxjs';
import { v4 as uuidv4 } from 'uuid';


@Injectable({
  providedIn: 'root'
})
export class OfferService {


  constructor(private http: HttpClient) { }

  // createOffer(staffId: string, roomId: string, offer: IOffer): Observable<any> {
  //   const url = `${this.apiUrl}/offer`;
  //   const headers = new HttpHeaders({
  //     'Content-Type': 'application/json',
  //     'Authorization': `Bearer ${this.getToken()}`
  //   });

  //   const body = {
  //     ...offer,
  //     id: this.generateOfferId()
  //   };

  //   const params = {
  //     staffId: staffId,
  //     roomId: roomId
  //   };

  //   return this.http.post(url, body, { headers, params });
  // }

  // private getToken(): string {
  //   return localStorage.getItem('token') || sessionStorage.getItem('token') || '';
  // }

  // private generateOfferId(): string {
  //   return 'off-' + Math.random().toString(36).substring(2, 8);
  // }

  addOffer(staffId: string, roomId: string, offer: IOffer): Observable<any> {
    const url = `/api/staff/offer?staffId=${staffId}&roomId=${roomId}`;
    console.log('Making offer request to:', url);

    const offerWithId = {
      ...offer,
      id: uuidv4() // Generate ID in service
    };
    console.log('Request payload:', offerWithId);

    const headers = new HttpHeaders({
      'Authorization': `Bearer ${localStorage.getItem('token') || sessionStorage.getItem('token')}`,
      'Content-Type': 'application/json'
    });

    return this.http.post(url, offerWithId, { headers, observe: 'response' }).pipe(
      tap({
        next: (response: HttpResponse<any>) => {
          console.log('Offer success:', response.body);
        },
        error: (error) => console.error('Offer error:', error)
      }),
      catchError(error => {
        console.error('Caught error:', error);
        return throwError(() => new Error('Failed to add offer. Check permissions or contact support.'));
      })
    );

  }

  getOffersByRoom(roomId: string): Observable<IOffer[]> {
    const url = `/api/staff/offers/room/${roomId}`;
    return this.http.get<IOffer[]>(url).pipe(
      catchError(error => {
        console.error('Error fetching offers:', error);
        return throwError(() => new Error('Failed to fetch offers'));
      })
    );
  }

  editOffer(staffId: string, roomId: string, offer: IOffer): Observable<any> {
    const url = `/api/staff/offer?staffId=${staffId}&roomId=${roomId}`;
    console.log('Editing offer request to:', url);

    const headers = new HttpHeaders({
      'Authorization': `Bearer ${localStorage.getItem('token') || sessionStorage.getItem('token')}`,
      'Content-Type': 'application/json'
    });

    return this.http.put(url, offer, { headers, observe: 'response' }).pipe(
      tap({
        next: (response: HttpResponse<any>) => console.log('Offer edited:', response.body),
        error: (error) => console.error('Edit offer error:', error)
      }),
      catchError(error => {
        console.error('Caught error:', error);
        return throwError(() => new Error('Failed to edit offer. Check permissions or contact support.'));
      })
    );
  }

  deleteOffer(offerId: string): Observable<any> {
    const url = `/api/staff/offer/${offerId}`;
    console.log('Deleting offer request to:', url);

    const headers = new HttpHeaders({
      'Authorization': `Bearer ${localStorage.getItem('token') || sessionStorage.getItem('token')}`
    });

    return this.http.delete(url, { headers, observe: 'response' }).pipe(
      tap({
        next: (response: HttpResponse<any>) => console.log('Offer deleted:', response.body),
        error: (error) => console.error('Delete offer error:', error)
      }),
      catchError(error => {
        console.error('Caught error:', error);
        return throwError(() => new Error('Failed to delete offer. Check permissions or contact support.'));
      })
    );
  }
}
