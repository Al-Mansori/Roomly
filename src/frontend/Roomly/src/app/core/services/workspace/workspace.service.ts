import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { catchError, map, Observable, tap, throwError } from 'rxjs';
import { IRoom, IWorkspace } from '../../../interfaces/iworkspace';
import { IWorkspaceAnalysisResponse } from '../../../interfaces/iworkspace-analysis';
import { Ishowworkspace } from '../../../interfaces/ishowworkspace';

@Injectable({
  providedIn: 'root'
})
export class WorkspaceService {

  constructor(private http: HttpClient) { }

  getWorkspacesByStaff(staffId: string): Observable<IWorkspace[]> {
    return this.http.get<IWorkspace[]>(`https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/workspaces?staffId=${staffId}`).pipe(
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
  const url = `api/staff/workspace?workspaceId=${workspaceId}`;
  
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

// في WorkspaceService
getWorkspaceById(workspaceId: string): Observable<Ishowworkspace> {
  return this.http.get<Ishowworkspace>(`https://feminist-abigael-roomly-5d3753ef.koyeb.app/api/staff/workspace?workspaceId=${workspaceId}`).pipe(
    catchError(error => {
      console.error('Error fetching workspace:', error);
      return throwError(() => new Error('Failed to fetch workspace'));
    })
  );
}

updateWorkspace(workspaceId: string, workspaceData: Partial<Ishowworkspace>): Observable<Ishowworkspace> {
  // إنشاء query params من البيانات
  const params = new HttpParams()
    .set('workspaceId', workspaceId)
    .set('name', workspaceData.name || '')
    .set('description', workspaceData.description || '')
    .set('address', workspaceData.address || '')
    .set('workspaceType', workspaceData.type || '')
    .set('paymentType', workspaceData.paymentType || '')
    .set('city', workspaceData.location?.city || '')
    .set('town', workspaceData.location?.town || '')
    .set('country', workspaceData.location?.country || '')
    .set('longitude', workspaceData.location?.longitude?.toString() || '')
    .set('latitude', workspaceData.location?.latitude?.toString() || '')
    .set('imageUrls', workspaceData.workspaceImages?.toString() || '')
    .set('staffId', workspaceData.staffId || '');

  return this.http.put<Ishowworkspace>(`api/staff/update-workspace`, {}, { params }).pipe(
    catchError(error => {
      console.error('Error updating workspace:', error);
      return throwError(() => new Error('Failed to update workspace'));
    })
  );
}


}
