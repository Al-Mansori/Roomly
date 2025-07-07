import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, map, Observable, throwError } from 'rxjs';
import { IRoom, IWorkspace } from '../../../interfaces/iworkspace';
import { IWorkspaceAnalysisResponse } from '../../../interfaces/iworkspace-analysis';

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
  // https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/workspace?workspaceId=8f9512fb-c555-4d1b-a148-8bc19a725327
  deleteWorkspace(workspaceId: string): Observable<any> {
    const url = `/api/staff/workspace?workspaceId=${workspaceId}`;
    return this.http.delete(url).pipe(
      catchError(error => {
        console.error('Error deleting workspace:', error);
        return throwError(() => new Error('Failed to delete workspace'));
      })
    );
  }

  // getWorkspaceAnalysis(workspaceId: string): Observable<IWorkspaceAnalysisResponse> {
  //   return this.http.get<IWorkspaceAnalysisResponse>
  //     (`https://mostafaabdelkawy-roomly-workspace-analysis.hf.space/api/v1/analysis/workspace/${workspaceId}/all`).pipe(
  //       // catchError(error => {
  //       //   console.error('Error fetching workspace analysis:', error);
  //       //   throw error;
  //       // })
  //       map(response => {
  //         // Try to replace NaN with null before JSON.parse
  //         const sanitized = response.replace(/\bNaN\b/g, 'null');
  //         return JSON.parse(sanitized) as IWorkspaceAnalysisResponse;
  //       }),
  //       catchError(err => {
  //         console.error('Error fetching workspace analysis:', err);
  //         return throwError(() => err);
  //       })
  //     );
  // }

  getWorkspaceAnalysis(workspaceId: string): Observable<IWorkspaceAnalysisResponse> {
    const url = `https://mostafaabdelkawy-roomly-workspace-analysis.hf.space/api/v1/analysis/workspace/${workspaceId}/all`;

    return this.http.get<string>(url, { responseType: 'text' as 'json' }).pipe(
      map((response: string) => {
        const sanitized = response.replace(/\bNaN\b/g, 'null');
        return JSON.parse(sanitized) as IWorkspaceAnalysisResponse;
      }),
      catchError(err => {
        console.error('Error fetching workspace analysis:', err);
        return throwError(() => err);
      })
    );
  }



}
