import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { IOffer, IRoom } from '../../../interfaces/iworkspace';
import { catchError, map, Observable, tap, throwError } from 'rxjs';
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
  const url = `/api/staff/room?id=${roomId}`;
  
  return this.http.delete(url, { 
    observe: 'response',  // للحصول على الاستجابة الكاملة
    responseType: 'text'  // تعطيل محاولة تحليل JSON
  }).pipe(
    map(response => {
      // أي استجابة 200 تعتبر نجاحاً حتى لو كانت فارغة
      if (response.status === 200) {
        return { success: true };
      }
      throw new Error('Delete operation failed');
    }),
    catchError(error => {
      console.error('Full error:', error);
      return throwError(() => new Error(error.message || 'Failed to delete workspace'));
    })
  );
}
    updateRoom(roomId: string, roomData: any, staffId: string): Observable<any> {
    const params = {
      roomId: roomId,
      staffId: staffId,
      ...roomData
    };
return this.http.put(`/staff/rooms/update-room`, params, {
  responseType: 'text' // ← هتمنعي Angular من محاولة عمل JSON.parse
}).pipe(
  map(res => {
    try {
      return JSON.parse(res); // نحاول نعمل parse يدوي
    } catch (e) {
      return { error: 'Invalid JSON from server', raw: res };
    }
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