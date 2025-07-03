import { CommonModule } from '@angular/common';
import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';

@Component({
  selector: 'app-post-preview',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './post-preview.component.html',
  styleUrl: './post-preview.component.scss'
})
export class PostPreviewComponent implements OnChanges {
  @Input() images: string[] = [];
  @Input() workspaceName: string = '';
  @Input() phone: string = '';
  @Input() description: string = '';
  @Input() markerPosition: google.maps.LatLngLiteral | null = null;
  @Input() address: string = '';
  @Input() town: string = '';
  @Input() city: string = '';
  @Input() country: string = '';

  ngOnChanges(changes: SimpleChanges) {
    if (changes['images']) {
      console.log('Images updated:', this.images.length);
    }
    if (changes['workspaceName'] || changes['phone'] || changes['description'] || changes['town'] || changes['city'] || changes['country']) {
      console.log('Form data updated:', { 
        name: this.workspaceName, 
        phone: this.phone, 
        description: this.description,
        town: this.town,
        city: this.city,
        country: this.country
      });
    }
    if (changes['markerPosition'] || changes['address']) {
      console.log('Location updated:', { 
        position: this.markerPosition, 
        address: this.address 
      });
    }
  }

  getStaticMapImage(): string {
    if (!this.markerPosition) return '';
    
    const { lat, lng } = this.markerPosition;
    // Replace YOUR_API_KEY with your actual Google Maps API key
    return `https://maps.googleapis.com/maps/api/staticmap?center=${lat},${lng}&zoom=15&size=600x300&markers=color:red%7C${lat},${lng}&key=YOUR_API_KEY`;
  }

  getMapPlaceholder(): string {
    return `https://via.placeholder.com/600x300/e9ecef/6c757d?text=Map+Preview`;
  }
}