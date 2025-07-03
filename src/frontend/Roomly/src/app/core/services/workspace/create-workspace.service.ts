import { Injectable } from '@angular/core';
import { environment } from '../../environment/environments';
import { HttpClient } from '@angular/common/http';
import Swal from 'sweetalert2';
import { firstValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CreateWorkspaceService {
  private baseUrl = environment.baseUrl;

  constructor(private http: HttpClient) {}

  async createWorkspace(workspaceData: any): Promise<any> {
    try {
      const queryParams = new URLSearchParams();

      // ضيفي الحقول إلى URLSearchParams بشكل يدوي
      for (const [key, value] of Object.entries(workspaceData)) {
        if (Array.isArray(value)) {
          value.forEach((v) => queryParams.append(key, v)); // array زي imageUrls
        } else {
          queryParams.append(key, String(value)); // باقي الحقول
        }
      }

      const url = `${this.baseUrl}/api/staff/create-workspace?${queryParams.toString()}`;

      const result: any = await firstValueFrom(this.http.post(url, {}));

      console.log('✅ API responded with:', result);

      const alertResult = await Swal.fire({
        icon: 'success',
        title: 'Done Successfully!',
        text: 'Now lets create your workspace room',
        confirmButtonText: 'Go to room page',
        showCancelButton: true,
        cancelButtonText: 'Stay here'
      });
      const { workspaceId } = result;

      return {
        success: true,
        navigate: alertResult.isConfirmed,
        workspaceId,
      };

    } catch (error) {
      console.error('❌ Error creating workspace:', error);

      await Swal.fire({
        icon: 'error',
        title: 'Error!',
        text: 'Something went wrong while creating the workspace',
        confirmButtonText: 'OK'
      });

      return { success: false, navigate: false };
    }
  }




}