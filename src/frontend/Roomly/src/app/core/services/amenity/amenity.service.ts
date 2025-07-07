import { Injectable } from '@angular/core';
import { IAmenity, IAmenityResponse, IExtendedAmenity } from '../../../interfaces/iamenity';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environment/environments';

@Injectable({
  providedIn: 'root'
})
export class AmenityService {
  private baseUrl = environment.baseUrl;

  constructor(private http: HttpClient) { }

  createAmenity(amenityData: IAmenity): Observable<IAmenityResponse> {
    // Create URL parameters
    let params = new HttpParams()
      .set('name', amenityData.name)
      .set('type', amenityData.type)
      .set('description', amenityData.description)
      .set('totalCount', amenityData.totalCount.toString())
      .set('roomId', amenityData.roomId)
      .set('staffId', amenityData.staffId);

    // Handle image URLs (assuming multiple URLs can be provided)
    amenityData.imageUrls.forEach((url, index) => {
      params = params.append('imageUrls', url);
    });

    return this.http.post<IAmenityResponse>(
      `${this.baseUrl}/staff/create-amenity`,
      {}, // empty body since we're using query params
      { params }
    );
  }

  updateAmenity(amenityData: IExtendedAmenity): Observable<IAmenityResponse> {
    let params = new HttpParams()
      .set('amenityId', amenityData.id || '')
      .set('name', amenityData.name)
      .set('type', amenityData.type)
      .set('description', amenityData.description)
      .set('totalCount', amenityData.totalCount.toString())
      .set('staffId', amenityData.staffId);

    if (amenityData.imageUrls && amenityData.imageUrls.length > 0) {
      amenityData.imageUrls.forEach((url) => {
        params = params.append('imageUrls', url);
      });
    }

    return this.http.put<IAmenityResponse>(
      `/api/staff/update-amenity`,
      {},
      { params }
    );
  }

  getAmenityById(amenityId: string): Observable<IExtendedAmenity> {
    return this.http.get<IExtendedAmenity>(`/api/staff/amenity/${amenityId}`);
  }
}



