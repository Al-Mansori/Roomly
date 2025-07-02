import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';
import { IRoom, IWorkspace } from '../../../interfaces/iworkspace';

@Injectable({
  providedIn: 'root'
})
export class WorkspaceService {



  // constructor(private http: HttpClient) {}

  // getWorkspacesByStaff(staffId: string): Observable<IWorkspace[]> {
  //   return this.http.get<IWorkspace[]>(`/api/staff/workspaces?staffId=${staffId}`);
  // }

  // getRoomsByWorkspace(workspaceId: string): Observable<IRoom[]> {
  //   return this.http.get<IRoom[]>(`/api/staff/room/workspace/${workspaceId}`);
  // }

  // getWorkspaceReviews(workspaceId: string): Observable<Review[]> {
  //   return this.http.get<Review[]>(`/api/customer/WorkspaceReviews?workspaceId=${workspaceId}`);
  // }
  constructor(private http: HttpClient) { }

  getWorkspacesByStaff(staffId: string): Observable<IWorkspace[]> {
    return this.http.get<IWorkspace[]>(`/api/staff/workspaces?staffId=${staffId}`).pipe(
      catchError(error => {
        console.error('Error fetching workspaces:', error);
        return throwError(() => new Error('Failed to fetch workspaces'));
      })
    );
  }

  getRoomsByWorkspace(workspaceId: string): Observable<IRoom[]> {
    return this.http.get<IRoom[]>(`/api/staff/room/workspace/${workspaceId}`).pipe(
      catchError(error => {
        console.error('Error fetching rooms:', error);
        return throwError(() => new Error('Failed to fetch rooms'));
      })
    );
  }
}
