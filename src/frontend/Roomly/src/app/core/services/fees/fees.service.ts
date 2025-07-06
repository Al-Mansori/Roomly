import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { IFeesRecommendationResponse } from '../../../interfaces/i-fees-recommendations';
import { catchError, Observable, throwError } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class FeesService {

  private readonly apiUrl = 'https://mostafaabdelkawy-roomly-ai.hf.space/api/v1/recommendations/cancellation-fees';

  constructor(private http: HttpClient) { }

  getCancellationFees(workspaceId: string): Observable<IFeesRecommendationResponse> {
    return this.http.get<IFeesRecommendationResponse>(`${this.apiUrl}/${workspaceId}`).pipe(
      catchError(this.handleError)
    );
  }

  private handleError(error: HttpErrorResponse): Observable<never> {
    let errorMessage = 'An error occurred while fetching cancellation fees.';
    if (error.status === 404) {
      errorMessage = 'Workspace not found.';
    } else if (error.status === 500) {
      errorMessage = 'Server error. Please try again later.';
    }
    return throwError(() => new Error(errorMessage));
  }
}
