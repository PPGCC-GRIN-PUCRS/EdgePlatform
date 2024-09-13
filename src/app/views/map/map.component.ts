import { ChangeDetectorRef, Component, OnInit, ViewChild } from '@angular/core';
import { MapAdvancedMarker, MapInfoWindow } from '@angular/google-maps';
import { ServerComponent } from '../../components/server/server.component';
import { GeolocalizationService } from './geolocalization.service';

@Component({
  selector: 'map-view',
  templateUrl: './map.component.html',
  styleUrl: './map.component.scss',
})
export class MapComponent {
  @ViewChild(MapInfoWindow) infoWindow!: MapInfoWindow;
  content: HTMLElement = new DOMParser().parseFromString(
    `<svg aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="#FF5733" stroke="#FFFFFF" viewBox="0 0 24 24">
    <path fill-rule="evenodd" d="M11.293 3.293a1 1 0 0 1 1.414 0l6 6 2 2a1 1 0 0 1-1.414 1.414L19 12.414V19a2 2 0 0 1-2 2h-3a1 1 0 0 1-1-1v-3h-2v3a1 1 0 0 1-1 1H7a2 2 0 0 1-2-2v-6.586l-.293.293a1 1 0 0 1-1.414-1.414l2-2 6-6Z" clip-rule="evenodd"/>
    </svg>`,
    'image/svg+xml'
  ).documentElement;

  options: google.maps.MapOptions;
  servers: ServerComponent[];
  styles;

  constructor(private geolocalizationService: GeolocalizationService) {
    this.styles = {
      default: [],
      hide: [
        {
          featureType: 'poi.business',
          stylers: [{ visibility: 'off' }],
        },
        {
          featureType: 'transit',
          elementType: 'labels.icon',
          stylers: [{ visibility: 'off' }],
        },
      ],
    };
    this.servers = [{ lat: -30.061138, lng: -51.173852, ip: this.content }];
    this.options = {
      center: { lat: -30.049629, lng: -51.1690065 },
      mapId: '2c9caaede23550a0',
      // styles: this.styles['hide'],
      // disableDefaultUI: true,
      // clickableIcons: false,
      zoom: 18,
    };
  }

  onMarkerClick(marker: MapAdvancedMarker) {
    this.infoWindow.open(marker, true, marker.advancedMarker.title);
  }

  public onMapReady(map: google.maps.Map): void {
    map.setOptions(this.options);
  }

  getLocation(): any {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) => {
        this.servers.push({
          lat: position.coords.latitude,
          lng: position.coords.longitude,
          ip: this.content,
        });
        return {
          lat: position.coords.latitude,
          lng: position.coords.longitude,
        };
      });
    } else {
      console.log('No support for geolocation');
    }
  }
}
