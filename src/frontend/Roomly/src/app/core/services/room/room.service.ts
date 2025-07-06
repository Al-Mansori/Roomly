import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { IOffer } from '../../../interfaces/iworkspace';
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

}
