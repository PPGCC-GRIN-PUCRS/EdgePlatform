import { Component, Inject, Injectable, Input } from '@angular/core';
import L from 'leaflet';
import { MarkerComponent } from '../marker.component';

@Component({
  selector: 'server-component',
  standalone: true,
  imports: [],
  styleUrl: './server.component.scss',
  template: ``,
})
export class ServerComponent extends MarkerComponent {
  latlng: L.LatLng;
  disabled: boolean;
  ip: string;

  constructor(
    @Inject(L.Map) map: L.Map,
    latlng: L.LatLng,
    @Inject(Boolean) disabled: boolean,
    @Inject(String) ip: string
  ) {
    super(
      latlng,
      `
      <div class="fa-2x">
        <i class="leaftlet-icon fas fa-server server-component-icon"></i>
      </div>
      ` as unknown as HTMLElement,
      [100, 100]
    );
    this.disabled = disabled;
    this.latlng = latlng;
    this.ip = ip;
    this.addTo(map);
  }

  override addTo(map: L.Map | L.LayerGroup): this {
    return super.addTo(map).bindPopup('self');
  }
}
