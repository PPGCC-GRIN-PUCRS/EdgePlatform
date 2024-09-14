import { ModuleWithProviders, NgModule, Type } from '@angular/core';
import { DevicesComponent } from './devices/devices.component';
import { CloudComponent } from './cloud/cloud.component';
import { EdgeComponent } from './edge/edge.component';
import { MapComponent } from './map/map.component';
import { CommonModule } from '@angular/common';

import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { GoogleMapsModule } from '@angular/google-maps';
import { ToastrModule } from 'ngx-toastr';
import { ComponentsModule } from '../components/components.module';

const moduleViews: Array<Type<any> | ModuleWithProviders<{}> | any[]> = [
  MapComponent,
  CloudComponent,
  EdgeComponent,
  DevicesComponent,
];

@NgModule({
  declarations: [moduleViews],
  imports: [CommonModule, GoogleMapsModule, ComponentsModule],
  exports: [moduleViews],
})
export class ViewsModule {}
