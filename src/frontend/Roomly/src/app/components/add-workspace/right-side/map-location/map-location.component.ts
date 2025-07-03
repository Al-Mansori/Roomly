import { Component, EventEmitter, Input, Output, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { FormControl, ReactiveFormsModule } from '@angular/forms';
import { CommonModule, isPlatformBrowser } from '@angular/common';
import { LeafletModule } from '@asymmetrik/ngx-leaflet';

@Component({
  selector: 'app-map-location',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule, LeafletModule],
  templateUrl: './map-location.component.html',
  styleUrls: ['./map-location.component.scss']
})
export class MapLocationComponent implements OnInit {
  @Input() initialAddress: string = '';
  @Input() initialPosition: { lat: number; lng: number } | null = null;
  @Output() locationChanged = new EventEmitter<{ position: { lat: number; lng: number }, address: string }>();
  @Output() locationRemoved = new EventEmitter<void>();

  isBrowser: boolean;
  mapInitialized = false;
  L: any;
  options: any;
  layers: any[] = [];
  marker: any;
  isEditing = false;
  locationControl = new FormControl('');
  selectedAddress = '';
  currentPosition: { lat: number; lng: number } | null = null;

  constructor(@Inject(PLATFORM_ID) private platformId: Object) {
    this.isBrowser = isPlatformBrowser(this.platformId);
  }

  async ngOnInit() {
    if (this.isBrowser) {
      await this.initializeMap();
    }

    if (this.initialAddress) {
      this.selectedAddress = this.initialAddress;
      this.locationControl.setValue(this.initialAddress);
    }

    this.isEditing = true;
  }

  private async initializeMap() {
    try {
      // Dynamic import for Leaflet
      this.L = await import('leaflet');
      
      // Fix for marker icons
      this.fixLeafletIcons();

      this.setupMapOptions();
      
      if (this.initialPosition) {
        this.currentPosition = this.initialPosition;
        this.addMarker(this.initialPosition);
      }

      this.mapInitialized = true;
    } catch (error) {
      console.error('Failed to initialize map:', error);
    }
  }

  private fixLeafletIcons() {
    const iconRetinaUrl = 'assets/leaflet/images/marker-icon-2x.png';
    const iconUrl = 'assets/leaflet/images/marker-icon.png';
    const shadowUrl = 'assets/leaflet/images/marker-shadow.png';

    delete (this.L.Icon.Default.prototype as any)._getIconUrl;
    this.L.Icon.Default.mergeOptions({
      iconRetinaUrl,
      iconUrl,
      shadowUrl
    });
  }

  private setupMapOptions() {
    this.options = {
      layers: [
        this.L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
          maxZoom: 18,
          attribution: '&copy; OpenStreetMap contributors'
        })
      ],
      zoom: 12,
      center: this.L.latLng(30.0444, 31.2357) // Cairo coordinates
    };
  }

  onMapClick(e: any) {
    if (!this.mapInitialized) return;

    const position = { lat: e.latlng.lat, lng: e.latlng.lng };
    this.currentPosition = position;
    this.addMarker(position);
    this.getAddressFromLatLng(position);
  }

  private addMarker(position: { lat: number; lng: number }) {
    if (!this.mapInitialized) return;

    // Remove existing marker
    if (this.marker) {
      this.layers = this.layers.filter(layer => layer !== this.marker);
    }

    // Add new marker
    this.marker = this.L.marker([position.lat, position.lng], {
      draggable: true
    }).on('dragend', (e: any) => {
      const newPos = e.target.getLatLng();
      this.currentPosition = { lat: newPos.lat, lng: newPos.lng };
      this.getAddressFromLatLng(this.currentPosition);
    });

    this.layers.push(this.marker);
  }

  async getAddressFromLatLng(position: { lat: number; lng: number }) {
    try {
      const response = await fetch(
        `https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.lat}&lon=${position.lng}`
      );
      const data = await response.json();
      this.selectedAddress = data.display_name || '';
      this.locationControl.setValue(this.selectedAddress);
      this.emitLocationChange(position);
    } catch (error) {
      console.error('Geocoding error:', error);
    }
  }

  search(event: Event) {
    if (!this.mapInitialized) return;

    const input = event.target as HTMLInputElement;
    if (!input.value.trim()) return;

    fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(input.value)}`)
      .then(response => response.json())
      .then(data => {
        if (data && data[0]) {
          const position = { lat: parseFloat(data[0].lat), lng: parseFloat(data[0].lon) };
          this.currentPosition = position;
          this.addMarker(position);
          this.selectedAddress = data[0].display_name || input.value;
          this.emitLocationChange(position);
        }
      })
      .catch(error => console.error('Search error:', error));
  }

  private emitLocationChange(position: { lat: number; lng: number }) {
    this.locationChanged.emit({
      position,
      address: this.selectedAddress
    });
  }

  startEditing() {
    this.isEditing = true;
  }

  saveChanges() {
    this.isEditing = false;
    if (this.currentPosition) {
      this.emitLocationChange(this.currentPosition);
    }
  }

  removeLocation() {
    if (!this.isBrowser) return;
    
    if (this.marker) {
      this.layers = this.layers.filter(layer => layer !== this.marker);
      this.marker = null;
    }
    this.currentPosition = null;
    this.selectedAddress = '';
    this.locationControl.setValue('');
    this.locationRemoved.emit();
  }
}