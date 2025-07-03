import { Component, EventEmitter, Inject, Input, Output, PLATFORM_ID } from '@angular/core';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { GoogleMapsModule } from '@angular/google-maps';
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { MapLocationComponent } from './map-location/map-location.component';

@Component({
  selector: 'app-right-side',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, MapLocationComponent ],
  templateUrl: './right-side.component.html',
  styleUrl: './right-side.component.scss'
})
export class RightSideComponent {
  zoom = 14;
  center: google.maps.LatLngLiteral = { lat: 30.0444, lng: 31.2357 };
  selectedAddress: string = '';
  isEditing: boolean = false;

  markerPosition: google.maps.LatLngLiteral | null = null;

  @Input() form!: FormGroup;
  @Output() locationChange = new EventEmitter<{ marker: google.maps.LatLngLiteral; address: string }>();
  @Output() formChange = new EventEmitter<any>();
  private isBrowser: boolean;

  constructor(@Inject(PLATFORM_ID) platformId: Object) {
    this.isBrowser = isPlatformBrowser(platformId);
  }


  ngOnInit() {

    this.form.valueChanges.subscribe(value => {
      this.formChange.emit(value);
    });
    this.isEditing = true;
  }

  updateLocation(event: google.maps.MapMouseEvent) {
    if (event.latLng) {
      this.markerPosition = {
        lat: event.latLng.lat(),
        lng: event.latLng.lng()
      };
      this.reverseGeocode(this.markerPosition);
      console.log('Location updated:', this.markerPosition); // لأغراض debugging
    }
  }

  search(event: Event) {
    const target = event.target as HTMLInputElement;
    if (!target?.value.trim()) return;

    const geocoder = new google.maps.Geocoder();
    geocoder.geocode({ address: target.value }, (results, status) => {
      if (status === 'OK' && results?.[0]?.geometry?.location) {
        const location = results[0].geometry.location;
        const marker = { lat: location.lat(), lng: location.lng() };
        this.markerPosition = marker;
        this.center = marker;
        this.selectedAddress = results[0].formatted_address || target.value;
        this.locationChange.emit({ marker, address: this.selectedAddress });
      }
    });
  }

  private reverseGeocode(position: google.maps.LatLngLiteral) {
    const geocoder = new google.maps.Geocoder();
    geocoder.geocode({ location: position }, (results, status) => {
      if (status === 'OK' && results?.[0]) {
        this.selectedAddress = results[0].formatted_address;
        this.locationChange.emit({ marker: position, address: this.selectedAddress });
      }
    });
  }

  // هذه هي الدالة المهمة التي كانت تحتاج إصلاح!
  onLocationChange(event: { position: google.maps.LatLngLiteral, address: string }) {
    console.log('📍 Location received from google-map-location:', event);
    
    // حفظ البيانات محلياً
    this.markerPosition = event.position;
    this.selectedAddress = event.address;
    
    // 🔥 الجزء المهم: إرسال البيانات للمكون الأب!
    this.locationChange.emit({ 
      marker: event.position, 
      address: event.address 
    });
    
    console.log('✅ Location data sent to parent component');
  }

  onLocationRemoved() {
    console.log('🗑️ Location removed');
    this.markerPosition = null;
    this.selectedAddress = '';
    
    // يمكن إضافة إشارة للمكون الأب أن الموقع تم حذفه
    // لكن هذا ليس ضرورياً للمشكلة الحالية
  }

  onInputChange() {
    this.formChange.emit(this.form.value);
  }

  getDescriptionLength(): number {
    return this.form.get('description')?.value?.length || 0;
  }

  get nameControl(): FormControl {
    return this.form.get('name') as FormControl;
  }

  get descriptionControl(): FormControl {
    return this.form.get('description') as FormControl;
  }

  get phoneControl(): FormControl {
    return this.form.get('phone') as FormControl;
  }

  get locationControl(): FormControl {
    return this.form.get('location') as FormControl;
  }

  get cityControl(): FormControl {
    return this.form.get('city') as FormControl;
  }

  get townControl(): FormControl {
    return this.form.get('town') as FormControl;
  }

  get countryControl(): FormControl {
    return this.form.get('country') as FormControl;
  }

  startEditing(): void {
    this.isEditing = true;
  }

  saveChanges(): void {
    this.isEditing = false;
    this.formChange.emit(this.form.value);
  }

  removeField(field: string): void {
    this.form.get(field)?.setValue('');
    this.formChange.emit(this.form.value);
  }
}

