import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { IOffer } from '../../../interfaces/iworkspace';
import { catchError, Observable, throwError } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class OfferService {

  private apiUrl = 'https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff';

  constructor(private http: HttpClient) {}

  createOffer(staffId: string, roomId: string, offer: IOffer): Observable<any> {
    const url = `${this.apiUrl}/offer`;
    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${this.getToken()}`
    });

    const body = {
      ...offer,
      id: this.generateOfferId()
    };

    const params = {
      staffId: staffId,
      roomId: roomId
    };

    return this.http.post(url, body, { headers, params });
  }

  private getToken(): string {
    return localStorage.getItem('token') || sessionStorage.getItem('token') || '';
  }

  private generateOfferId(): string {
    return 'off-' + Math.random().toString(36).substring(2, 8);
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
}
