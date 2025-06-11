import { Component} from '@angular/core';
import { SideStepsIndicatorComponent } from "../side-steps-indicator/side-steps-indicator.component";
// import { LeafletModule } from '@asymmetrik/ngx-leaflet';

@Component({
  selector: 'app-add-workspace',
  standalone: true,
  imports: [SideStepsIndicatorComponent],
  templateUrl: './add-workspace.component.html',
  styleUrl: './add-workspace.component.scss'
})
export class AddWorkspaceComponent /*implements OnInit */{
  steps = [
    { icon: 'Add Worksapce step indicator.png', label: 'Add Workspace', active: true },
    { icon: 'Add Rooms step indicator.png', label: 'Rooms', active: false },
    { icon: 'Add amenities step indicator.png', label: 'Amenities', active: false },
    { icon: 'Reception hours step indicator.png', label: 'Recipients', active: false }
  ];

  // mapCenter: any;
  // mapZoom: number = 13;
  // mapOptions: any;
  // marker: any = null;

  // constructor(@Inject(PLATFORM_ID) private platformId: Object) {}

  // async ngOnInit() {
  //   if (isPlatformBrowser(this.platformId)) {
  //     const L = await import('leaflet');
  //     this.mapCenter = L.latLng(30.0444, 31.2357);
  //     this.mapOptions = {
  //       layers: [
  //         L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  //           maxZoom: 19,
  //           attribution: '© OpenStreetMap'
  //         })
  //       ],
  //       zoomControl: false,
  //       attributionControl: false
  //     };
  //   }
  // }

  // async onMapClick(event: any) {
  //   if (isPlatformBrowser(this.platformId)) {
  //     const L = await import('leaflet');
  //     const lat = event.latlng.lat;
  //     const lng = event.latlng.lng;
  //     this.mapCenter = L.latLng(lat, lng);
  //     if (this.marker) {
  //       this.marker.setLatLng(this.mapCenter);
  //     } else {
  //       this.marker = L.marker(this.mapCenter).addTo(event.target);
  //     }
  //   }
  // }
}
