import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { IOffer, IRoom, IRoomAmenity } from '../../../interfaces/iworkspace';
import { catchError, Observable, tap, throwError } from 'rxjs';
import { v4 as uuidv4 } from 'uuid';
import { IRecommendationResponse } from '../../../interfaces/irecommendation';

@Injectable({
  providedIn: 'root'
})
export class RoomService {


  constructor(private http: HttpClient) { }

  deleteRoom(roomId: string): Observable<any> {
    const url = `/staff/rooms/${roomId}`;
    return this.http.delete(url).pipe(
      catchError(error => {
        console.error('Error deleting room:', error);
        return throwError(() => new Error('Failed to delete room'));
      })
    );
  }
  getRecommendations(workspaceId: string): Observable<IRecommendationResponse> {
    const url = `https://mostafaabdelkawy-roomly-room.hf.space/api/v1/recommendations/rooms?workspace_id=${workspaceId}`;
    return this.http.get<IRecommendationResponse>(url).pipe(
      catchError(error => {
        console.error('Error fetching recommendations:', error);
        return throwError(() => new Error('Failed to fetch recommendations'));
      })
    );
  }

  getRoomById(roomId: string): Observable<IRoom> {
    return this.http.get<IRoom>(`/api/staff/room/${roomId}`).pipe(
      catchError(error => {
        console.error(`Error fetching room ${roomId}:`, error);
        return throwError(() => new Error('Failed to fetch room details'));
      })
    );
  }
  getAmenitiesByRoom(roomId: string): Observable<IRoomAmenity[]> {
    return this.http.get<IRoomAmenity[]>(`/api/staff/amenity/room/${roomId}`).pipe(
      catchError(error => {
        console.error(`Error fetching amenities for room ${roomId}:`, error);
        return throwError(() => new Error('Failed to fetch amenities'));
      })
    );
  }



  addAmenity(roomId: string, amenity: any): Observable<any> {
    return this.http.post(`/api/staff/amenity/${roomId}`, amenity).pipe(
      catchError(error => {
        console.error('Error adding amenity:', error);
        return throwError(() => new Error('Failed to add amenity'));
      })
    );
  }

  updateAmenity(amenity: any): Observable<any> {
    return this.http.post(`/api/staff/amenity`, amenity).pipe(
      catchError(error => {
        console.error('Error updating amenity:', error);
        return throwError(() => new Error('Failed to update amenity'));
      })
    );
  }

  deleteAmenity(amenityId: string): Observable<string> {
    return this.http.delete(`/api/staff/amenity/${amenityId}`, { responseType: 'text' }).pipe(
      catchError(error => {
        console.error('Error deleting amenity:', error);
        return throwError(() => new Error('Failed to delete amenity'));
      })
    );
  }

}
