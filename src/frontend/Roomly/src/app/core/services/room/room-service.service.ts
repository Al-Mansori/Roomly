import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { firstValueFrom } from 'rxjs';
import Swal from 'sweetalert2';
import { environment } from '../../environment/environments';

@Injectable({
  providedIn: 'root'
})
export class RoomServiceService {
  private readonly baseUrl = environment.baseUrl;
  private readonly createRoomEndpoint = `${this.baseUrl}/api/staff/create-room`;

  constructor(private http: HttpClient) { }

  /**
   * إنشاء غرفة جديدة
   * @param roomData بيانات الغرفة
   * @param staffId معرف الموظف
   * @param workspaceId معرف مساحة العمل
   * @returns Promise يحتوي على نتيجة العملية
   */
  async createRoom(roomData: any, staffId: string, workspaceId: string): Promise<RoomCreationResult> {
    try {
      // التحقق من البيانات المطلوبة
      if (!staffId || !workspaceId) {
        throw new Error('Staff ID and Workspace ID are required');
      }

      // بناء معاملات URL
      const queryParams = new URLSearchParams();
      
      // إضافة المعلمات الأساسية
      queryParams.append('staffId', staffId);
      queryParams.append('workspaceId', workspaceId);

      // إضافة باقي بيانات الغرفة
      for (const [key, value] of Object.entries(roomData)) {
        if (value === null || value === undefined) continue;

        if (Array.isArray(value)) {
          value.forEach(v => queryParams.append(key, String(v)));
        } else {
          queryParams.append(key, String(value));
        }
      }

      // إرسال الطلب إلى API
      const url = `${this.createRoomEndpoint}?${queryParams.toString()}`;
      const result = await firstValueFrom(this.http.post<RoomResponse>(url, {}));

      // عرض رسالة النجاح
      await this.showSuccessAlert('Room created successfully!');

      return {
        success: true,
        data: result
      };

    } catch (error) {
      // معالجة الأخطاء
      return this.handleError(error);
    }
  }

  /**
   * عرض رسالة نجاح
   * @param message نص الرسالة
   */
  private async showSuccessAlert(message: string): Promise<void> {
    await Swal.fire({
      icon: 'success',
      title: 'Success!',
      text: message,
      timer: 3000,
      showConfirmButton: false
    });
  }

  /**
   * معالجة الأخطاء
   * @param error الخطأ
   * @returns نتيجة تحتوي على حالة الفشل
   */
  private async handleError(error: any): Promise<RoomCreationResult> {
    console.error('Error creating room:', error);

    let errorMessage = 'Something went wrong while creating the room';
    
    if (error instanceof Error) {
      errorMessage = error.message;
    } else if (error.error?.message) {
      errorMessage = error.error.message;
    }

    await Swal.fire({
      icon: 'error',
      title: 'Error!',
      text: errorMessage,
      confirmButtonText: 'OK'
    });

    return {
      success: false,
      error: errorMessage
    };
  }
}

// واجهات TypeScript لتحسين نوعية الكود
interface RoomResponse {
  id: string;
  // يمكن إضافة المزيد من الخصائص حسب استجابة API
}

interface RoomCreationResult {
  success: boolean;
  data?: RoomResponse;
  error?: string;
}