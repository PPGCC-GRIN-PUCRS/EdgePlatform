import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MapComponent } from './map/map.component';
import { CloudComponent } from './cloud/cloud.component';
import { EdgeComponent } from './edge/edge.component';
import { DevicesComponent } from './devices/devices.component';

import { GoogleMapsModule } from '@angular/google-maps';
import { ToastrModule } from 'ngx-toastr';

const moduleViews: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  MapComponent,
  CloudComponent,
  EdgeComponent,
  DevicesComponent,
];

@NgModule({
  declarations: [moduleViews],
  imports: [
    CommonModule,
    GoogleMapsModule,
    ToastrModule.forRoot({
      preventDuplicates: false,
      progressBar: true,
      countDuplicates: true,
      extendedTimeOut: 3000,
      positionClass: 'toast-bottom-right',
    }),
  ],
  exports: [moduleViews],
})
export class ViewsModule {}
