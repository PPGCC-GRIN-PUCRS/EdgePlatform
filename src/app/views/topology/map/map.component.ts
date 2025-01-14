import { AfterViewInit, Component, OnInit } from '@angular/core';
import { ServerComponent } from 'src/app/components/marker/server/server.component';
import { ToastrService } from 'ngx-toastr';
import * as L from 'leaflet';
import { MarkerComponent } from 'src/app/components/marker/marker.component';
import { AppComponent } from 'src/app/app.component';

@Component({
  selector: 'map-view',
  templateUrl: './map.component.html',
  styleUrl: './map.component.scss',
})
export class MapComponent implements AfterViewInit, OnInit {
  private PUCRSLocation: { lat: number; lng: number };
  private servers: MarkerComponent[];
  private zoomScale: number;
  private map: any;

  constructor(
    private toastrService: ToastrService,
    private appComponent: AppComponent
  ) {
    this.appComponent.enableSidebar();
    this.PUCRSLocation = { lat: -30.061108487534216, lng: -51.17391422126215 };
    this.zoomScale = 18;
    this.servers = [];
  }

  ngOnInit(): void {
    this.map = L.map('map');
  }

  ngAfterViewInit(): void {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((location) => {
        if (location.coords.accuracy > 800) {
          this.zoomScale = 17;
          this.toastrService.warning(
            `[${location.coords.latitude}, ${location.coords.longitude}] ~ ${location.coords.accuracy}. Back to PUC Default.`,
            'Geolocation found, but are not accuratele'
          );

          // this.buildMap(location.coords.latitude, location.coords.longitude);
          this.buildMap(this.PUCRSLocation.lat, this.PUCRSLocation.lng);
        } else {
          this.toastrService.success(
            `[${location.coords.latitude}, ${location.coords.longitude}] ~ ${location.coords.accuracy}`,
            'Geolocation found'
          );

          this.buildMap(location.coords.latitude, location.coords.longitude);
        }
      });
    } else {
      this.toastrService.warning(
        'Geolocation is not allowed by the browser.\n Using PUC default [-30.049629, -51.1690065]',
        'No Geolocation found'
      );
      this.buildMap(-30.049629, -51.1690065);
    }
  }

  buildMap(latitude: number, longitude: number) {
    this.map.setView([latitude, longitude], this.zoomScale);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution:
        '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>contributors',
    }).addTo(this.map);

    this.map.on('click', (e: { latlng: { lat: number; lng: number } }) => {
      const server = new ServerComponent(
        this.map,
        e.latlng as L.LatLng,
        false,
        '10.32.223.4'
      );
      this.servers.push(server);
    });
  }
}
