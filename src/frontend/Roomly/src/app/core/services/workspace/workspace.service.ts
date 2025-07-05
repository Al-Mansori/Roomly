import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, Observable, throwError } from 'rxjs';
import { IRoom, IWorkspace } from '../../../interfaces/iworkspace';

@Injectable({
  providedIn: 'root'
})
export class WorkspaceService {

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

  deleteWorkspace(workspaceId: string): Observable<any> {
    const url = `/api/staff/workspaces/${workspaceId}`;
    return this.http.delete(url).pipe(
      catchError(error => {
        console.error('Error deleting workspace:', error);
        return throwError(() => new Error('Failed to delete workspace'));
      })
    );
  }
  getWorkspaceAnalysis(workspaceId: string): Observable<any> {
    return this.http.get(`https://mostafaabdelkawy-roomly-workspace-analysis.hf.space/api/v1/analysis/workspace/${workspaceId}/all`).pipe(
      catchError(error => {
        console.error('Error fetching workspace analysis:', error);
        throw error;
      })
    );
  }
}
