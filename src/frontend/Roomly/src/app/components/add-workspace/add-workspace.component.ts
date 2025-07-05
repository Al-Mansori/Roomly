import { Component, OnInit } from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";
import { LeftSideComponent } from './left-side/left-side.component';
import { RightSideComponent } from './right-side/right-side.component';
import { PostPreviewComponent } from './post-preview/post-preview.component';
import { FormBuilder, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { WorkspacePlanComponent } from './workspace-plan/workspace-plan.component';
import { CreateWorkspaceService } from '../../core/services/workspace/create-workspace.service';
import Swal from 'sweetalert2';
import { Router, RouterModule } from '@angular/router';

@Component({
  selector: 'app-add-workspace',
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
  templateUrl: './add-workspace.component.html',
  styleUrl: './add-workspace.component.scss'
})
export class AddWorkspaceComponent implements OnInit {
  workspaceForm: FormGroup;
  images: string[] = [];
  markerPosition: google.maps.LatLngLiteral | null = null;
  selectedAddress: string = '';
  paymentType: string = '';
  workspacePlanType: string = '';
  workspaceId: string | null = null;

  // steps = [
  //   { icon: 'Add Worksapce step indicator.png', label: 'Add Workspace', active: true },
  //   { icon: 'Add Rooms step indicator.png', label: 'Rooms', active: false },
  //   { icon: 'Add amenities step indicator.png', label: 'Amenities', active: false },
  //   { icon: 'Reception hours step indicator.png', label: 'Recipients', active: false }
  // ];

  constructor(private fb: FormBuilder,
    private CreateWorkspaceService: CreateWorkspaceService,
    private router: Router
) {

this.workspaceForm = this.fb.group({
  name: ['', [Validators.required, Validators.minLength(3)]],
  phone: ['', [Validators.required, Validators.pattern(/^[0-9]+$/)]],
  description: ['', [Validators.required, Validators.maxLength(500)]],
  city: ['', Validators.required],
  town: [''],
  country: ['', Validators.required]
});
    
  }

  ngOnInit() {
    this.workspaceForm.valueChanges.subscribe(value => {
      console.log('📝 Form values changed:', value);
      console.log('📝 Form valid:', this.workspaceForm.valid);
    });
  }

  // Called by LeftSideComponent when images change
  updateImages(images: string[]) {
    this.images = [...images]; // Create new array reference for change detection
    console.log('🖼️ Images updated:', this.images.length, 'images');
  }

  // Called by RightSideComponent when location changes
  updateLocation(marker: google.maps.LatLngLiteral, address: string) {
    console.log('🎯 LOCATION UPDATE RECEIVED IN MAIN COMPONENT!');
    console.log('📍 Marker:', marker);
    console.log('📍 Address:', address);
    
    this.markerPosition = marker;
    this.selectedAddress = address;
    
    console.log('✅ Location saved in main component');
    console.log('✅ markerPosition is now:', this.markerPosition);
  }
  
  // Called by WorkspacePlanComponent when plan data changes
  updateWorkspacePlan(data: { paymentType: string, workspaceType: string }) {
    this.paymentType = data.paymentType;
    this.workspacePlanType = data.workspaceType;
    console.log('📋 Workspace plan updated:', data);
  }

  // Called by RightSideComponent when form data changes
  onFormChange(formData: any) {
    // Update form values directly from the emitted data
    this.workspaceForm.patchValue(formData);
  }
  
async onSubmit() {
  if (!this.workspaceForm.valid || this.images.length === 0 || !this.markerPosition) {
    await Swal.fire({
      icon: 'warning',
      title: 'بيانات ناقصة',
      text: 'يرجى إكمال جميع الحقول المطلوبة',
      confirmButtonText: 'حسناً'
    });
    return;
  }

  const formData = {
    name: this.workspaceForm.get('name')?.value,
    description: this.workspaceForm.get('description')?.value,
    address: this.selectedAddress,
    workspaceType: this.workspacePlanType,
    paymentType: this.paymentType,
    city: this.workspaceForm.get('city')?.value,
    town: this.workspaceForm.get('town')?.value,
    country: this.workspaceForm.get('country')?.value,
    longitude: this.markerPosition?.lng,
    latitude: this.markerPosition?.lat,
    imageUrls: this.images.join(','), // إرسال روابط الصور كمصفوفة
    staffId: this.getUserId()
  };

  try {
    const result = await this.CreateWorkspaceService.createWorkspace(formData);
    
    if (result.success) {
      this.router.navigate(['/add-rooms'], {
        queryParams: { workspaceId: result.workspaceId }
      });
    }
  } catch (error) {
    console.error('Error creating workspace:', error);
    Swal.fire({
      icon: 'error',
      title: 'خطأ',
      text: 'حدث خطأ أثناء إنشاء مساحة العمل',
      confirmButtonText: 'حسناً'
    });
  }
}

private getUserId(): string {
  const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
  return user?.id || '';
}

  private prepareFormData() {
    const user = JSON.parse(localStorage.getItem('user') || sessionStorage.getItem('user') || '{}');
    return {
      id: this.generateTempId(), // إذا كنت تحتاج ID مؤقت
      name: this.workspaceForm.get('name')?.value,
      description: this.workspaceForm.get('description')?.value,
      address: this.selectedAddress,
      workspaceType: this.workspacePlanType,
      paymentType: this.paymentType.toUpperCase(),
      city: this.workspaceForm.get('city')?.value,
      town: this.workspaceForm.get('town')?.value,
      country: this.workspaceForm.get('country')?.value,
      longitude: this.markerPosition?.lng,
      latitude: this.markerPosition?.lat,
      imageUrls: this.images.join(','),
      staffId: user?.id
    };
  }

  private generateTempId() {
    return 'temp_' + Math.random().toString(36).substr(2, 9);
  }






// دالة التحقق من صحة البيانات مع debugging مفصل
isSubmitDisabled(): boolean {
  const formValid = this.workspaceForm.valid;
  const hasImages = this.images.length > 0;
  const hasLocation = this.markerPosition !== null;
  const hasPlanData = this.paymentType && this.paymentType.trim() !== '' && 
                      this.workspacePlanType && this.workspacePlanType.trim() !== '';
  
  // تفاصيل أكثر للـ debugging
  const formErrors = Object.keys(this.workspaceForm.controls).reduce((errors: any, key) => {
    const control = this.workspaceForm.get(key);
    if (control && control.errors) {
      errors[key] = control.errors;
    }
    return errors;
  }, {});
  
  console.log('=== Submit Validation Status ===');
  console.log('Form valid:', formValid);
  console.log('Form errors:', formErrors);
  console.log('Has images:', hasImages, '(count:', this.images.length, ')');
  console.log('Has location:', hasLocation, '(position:', this.markerPosition, ')');
  console.log('Has plan data:', hasPlanData);
  console.log('Payment type:', this.paymentType);
  console.log('Workspace type:', this.workspacePlanType);
  console.log('Submit disabled:', !(formValid && hasImages && hasLocation && hasPlanData));
  console.log('================================');

  return !(formValid && hasImages && hasLocation && hasPlanData);
}

}