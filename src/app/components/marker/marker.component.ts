import { Component, Inject } from '@angular/core';
import * as L from 'leaflet';

@Component({
  selector: 'marker-component',
  standalone: true,
  styleUrl: './marker.component.scss',
  template: ``,
})
export class MarkerComponent extends L.Marker {
  constructor(
    latlng: L.LatLng,
    html?: HTMLElement,
    @Inject(L.Point) iconSize?: L.PointTuple
  ) {
    console.log(iconSize);
    const options: L.MarkerOptions = {
      icon: L.divIcon({
        html: html
          ? html
          : '<i class="leaftlet-icon fa fa-map-marker fa-2x"></i>',
        iconSize: iconSize ? iconSize : [10, 10],
        className: 'leaftlet-icon',
      }),
    };
    super(latlng, options);
  }
}
