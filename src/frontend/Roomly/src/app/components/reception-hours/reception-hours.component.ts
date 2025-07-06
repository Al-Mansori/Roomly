// reception-hours.component.ts
import { Component } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import Swal from 'sweetalert2';
import { CreateWorkspaceService } from '../../core/services/workspace/create-workspace.service';

@Component({
  selector: 'app-reception-hours',
  standalone: true,
  imports: [CommonModule, SideStepsIndicatorComponent, FormsModule, SideStepsIndicatorComponent],
  templateUrl: './reception-hours.component.html',
  styleUrl: './reception-hours.component.scss'
})
export class ReceptionHoursComponent {
  
  steps = [
    { icon: 'Add Worksapce step indicator.png', label: 'Add Workspace', active: true },
    { icon: 'Add Rooms step indicator.png', label: 'Rooms', active: true },
    { icon: 'Add amenities step indicator.png', label: 'Amenities', active: true },
    { icon: 'Reception hours step indicator.png', label: 'Recipients', active: true }
  ];

  days = [
    { id: 0, label: 'all days', startTime: '08:00', endTime: '20:00' }, // تم تغيير هذا السطر
    { id: 1, label: 'saturday', startTime: '08:00', endTime: '20:00' },
    { id: 2, label: 'sunday', startTime: '08:00', endTime: '20:00' },
    { id: 3, label: 'monday', startTime: '08:00', endTime: '20:00' },
    { id: 4, label: 'tuesday', startTime: '08:00', endTime: '20:00' },
    { id: 5, label: 'wednesday', startTime: '08:00', endTime: '20:00' },
    { id: 6, label: 'thursday', startTime: '08:00', endTime: '20:00' },
    { id: 7, label: 'friday', startTime: '08:00', endTime: '20:00' }
  ];

  workspaceId: string | null = null;

  constructor(
    private createWorkspaceService: CreateWorkspaceService,
    private router: Router,
    private route: ActivatedRoute
  ) {
    this.route.queryParams.subscribe(params => {
      this.workspaceId = params['workspaceId'] || null;
    });
  }
  ngOnInit() {
    this.route.queryParams.subscribe(params => {
      this.workspaceId = params['workspaceId'] || null;
      if (this.workspaceId) {
        console.log('تم استقبال workspaceId:', this.workspaceId);
      }
    });
  }

async submitHours() {
  if (!this.workspaceId) {
    Swal.fire('Error', 'Workspace ID is missing', 'error');
    return;
  }

  // إنشاء القائمة النهائية للإرسال (تجاهل العنصر الأول "all days")
  const schedules = this.days.slice(1).map(day => ({
    day: day.label.charAt(0).toUpperCase() + day.label.slice(1),
    startTime: day.startTime,
    endTime: day.endTime,
    workspaceId: this.workspaceId
  }));

  // طباعة البيانات قبل الإرسال
  console.log('--- DEBUG INFO ---');
  console.log('Workspace ID:', this.workspaceId);
  console.log('Schedules to send:', schedules);
  console.log('------------------');

  try {
    const result = await this.createWorkspaceService.setReceptionHours(schedules, this.workspaceId);

    // طباعة النتيجة الراجعة من السيرفيس
    console.log('API Response:', result);

    if (result.success) {
      await Swal.fire({
        icon: 'success',
        title: 'Success!',
        text: 'Reception hours added successfully',
        confirmButtonText: 'Go to Home'
      });
      this.router.navigate(['/home']);
    } else {
      console.error('Error from server:', result.message);
      Swal.fire('Error', result.message || 'Failed to save reception hours', 'error');
    }
  } catch (error) {
    // طباعة الخطأ لو حصل استثناء أثناء الإرسال
    console.error('Error submitting reception hours:', error);
    Swal.fire('Error', 'Failed to save reception hours', 'error');
  }
}
  // تطبيق التغييرات على جميع الأيام
  applyToAllDays() {
    const startTime = this.days[0].startTime; // استخدام القيمة من all days
    const endTime = this.days[0].endTime; // استخدام القيمة من all days

    // تطبيق على جميع الأيام ما عدا all days
    for (let i = 1; i < this.days.length; i++) {
      this.days[i].startTime = startTime;
      this.days[i].endTime = endTime;
    }

    Swal.fire('Applied!', 'Times have been applied to all days', 'success');
  }
}