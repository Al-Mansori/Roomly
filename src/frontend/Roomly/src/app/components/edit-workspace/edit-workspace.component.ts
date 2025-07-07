import { Component, Input, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { WorkspaceService } from '../../core/services/workspace/workspace.service';
import { Router, ActivatedRoute, RouterModule } from '@angular/router';
import Swal from 'sweetalert2';
import { Ishowworkspace } from '../../interfaces/ishowworkspace';
import { SideStepsIndicatorComponent } from '../side-steps-indicator/side-steps-indicator.component';
import { LeftSideComponent } from '../add-workspace/left-side/left-side.component';
import { RightSideComponent } from '../add-workspace/right-side/right-side.component';
import { PostPreviewComponent } from '../add-workspace/post-preview/post-preview.component';
import { WorkspacePlanComponent } from '../add-workspace/workspace-plan/workspace-plan.component';

@Component({
    standalone: true,
    imports: [
      SideStepsIndicatorComponent, 
      LeftSideComponent, 
      RightSideComponent, 
      PostPreviewComponent,
      ReactiveFormsModule,
      WorkspacePlanComponent,
      RouterModule
    ],
  
  selector: 'app-edit-workspace',
  templateUrl: './edit-workspace.component.html',
  styleUrls: ['./edit-workspace.component.scss']
})
export class EditWorkspaceComponent implements OnInit {
  workspaceForm: FormGroup;
  images: string[] = [];
  markerPosition: google.maps.LatLngLiteral | null = null;
  selectedAddress: string = '';
  paymentType: string = '';
  workspacePlanType: string = '';
  workspaceId: string | null = null;
  isLoading: boolean = true;
  originalWorkspaceData: Ishowworkspace | null = null;
@Input() initialImages: string[] = [];
  constructor(
    private fb: FormBuilder,
    private workspaceService: WorkspaceService,
    private router: Router,
    private route: ActivatedRoute
  ) {
    this.workspaceForm = this.fb.group({
      name: ['', [Validators.minLength(3)]],
      phone: ['', [ Validators.pattern(/^[0-9]+$/)]],
      description: ['', [ Validators.maxLength(500)]],
      city: [''],
      town: [''],
      country: ['']
    });
  }

  ngOnInit() {
      if (this.initialImages.length > 0) {
    this.images = [...this.initialImages];
  }

    this.route.paramMap.subscribe(params => {
      this.workspaceId = params.get('id');
      if (this.workspaceId) {
        this.loadWorkspaceData(this.workspaceId);
      }
    });
  }

  private getUserId(): string {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    return user?.id || '';
  }

// تعديل دالة loadWorkspaceData
loadWorkspaceData(workspaceId: string) {
  console.log('Loading workspace with ID:', workspaceId);
  this.isLoading = true;
  this.workspaceService.getWorkspaceById(workspaceId).subscribe({
    next: (workspace) => {
      console.log('Received workspace data:', workspace);
      this.originalWorkspaceData = workspace;
      this.populateForm(workspace);
      this.isLoading = false;
    },
    error: (err) => {
      console.error('Error loading workspace:', err);
      // ...
    }
  });
}

// تعديل دالة prepareFormData
private prepareFormData(): Partial<Ishowworkspace> {
  const locationData = {
    city: this.workspaceForm.get('city')?.value,
    town: this.workspaceForm.get('town')?.value,
    country: this.workspaceForm.get('country')?.value,
    longitude: this.markerPosition?.lng || 0, // القيمة الافتراضية 0
    latitude: this.markerPosition?.lat || 0   // القيمة الافتراضية 0
  };

  return {
    name: this.workspaceForm.get('name')?.value,
    description: this.workspaceForm.get('description')?.value,
    address: this.selectedAddress,
    type: this.workspacePlanType,
    paymentType: this.paymentType,
    location: locationData,
    workspaceImages: this.images.join(','),
    staffId: this.getUserId()
  };
}  

populateForm(workspace: Ishowworkspace) {
  // تعبئة النموذج بالبيانات الأساسية
  this.workspaceForm.patchValue({
    name: workspace.name,
    phone: workspace.phone , // تأكدي من وجود حقل الهاتف
    description: workspace.description,
    city: workspace.location?.city || '',
    town: workspace.location?.town || '',
    country: workspace.location?.country || ''
  });

  // تعيين الخصائص الأخرى
  this.selectedAddress = workspace.address || '';
  this.paymentType = workspace.paymentType || '';
  this.workspacePlanType = workspace.type || '';
  
  // تعيين موقع الخريطة
  if (workspace.location?.latitude && workspace.location?.longitude) {
    this.markerPosition = {
      lat: workspace.location.latitude,
      lng: workspace.location.longitude
    };
  }

  // تعيين الصور
  if (workspace.workspaceImages) {
    this.images = workspace.workspaceImages.split(',').filter(img => img.trim() !== '');
  }
}
async onSubmit() {
  if (!this.workspaceId) {
    await Swal.fire('Error', 'Workspace ID is missing', 'error');
    return;
  }

  const formData = this.prepareFormData();
  console.log('Submitting data:', formData); // لأغراض debugging

  try {
    const result = await this.workspaceService.updateWorkspace(this.workspaceId, formData).toPromise();
    
    if (result) {
      await Swal.fire('Success', 'Workspace updated successfully', 'success');
      this.router.navigate(['/workspace-details', this.workspaceId]);
    }
  } catch (error) {
    console.error('Error updating workspace:', error);
    Swal.fire('Error', 'Failed to update workspace', 'error');
  }
}

private hasChanges(): boolean {
  if (!this.originalWorkspaceData) return true;

  const currentData = this.prepareFormData();
  const originalData = {
    ...this.originalWorkspaceData,
    location: {
      ...this.originalWorkspaceData.location,
      latitude: this.originalWorkspaceData.location?.latitude || null,
      longitude: this.originalWorkspaceData.location?.longitude || null
    }
  };

  return JSON.stringify(currentData) !== JSON.stringify(originalData);
}

// إضافة هذه الدالة للتحقق من حالة التحميل في القالب
isLoadingTemplate(): boolean {
  return this.isLoading;
}

// تحسين دالة prepareFormData لإصلاح خطأ مطبعي
isSubmitDisabled(): boolean {
  // إذا لم يتم عمل أي تغييرات
  if (!this.hasChanges()) {
    return true;
  }

  // إذا كان هناك تغييرات ولكن بعض الحقول الأساسية مفقودة
  const requiredFields = [
    this.workspaceForm.get('name')?.value,
    this.selectedAddress,
    this.markerPosition,
    this.paymentType,
    this.workspacePlanType
  ];

  return requiredFields.some(field => !field);
}

  // إضافة هذه الدوال داخل class EditWorkspaceComponent

// Called by LeftSideComponent when images change
updateImages(images: string[]) {
  this.images = [...images];
  console.log('Images updated:', this.images);
}

// Called by RightSideComponent when location changes
updateLocation(marker: google.maps.LatLngLiteral, address: string) {
  this.markerPosition = marker;
  this.selectedAddress = address;
  console.log('Location updated:', marker, address);
}

// Called by WorkspacePlanComponent when plan data changes
updateWorkspacePlan(data: { paymentType: string, workspaceType: string }) {
  this.paymentType = data.paymentType;
  this.workspacePlanType = data.workspaceType;
  console.log('Workspace plan updated:', data);
}

// Called by RightSideComponent when form data changes
onFormChange(formData: any) {
  this.workspaceForm.patchValue(formData);
}
}