import { DevicesComponent } from './views/devices/devices.component';
import { CloudComponent } from './views/cloud/cloud.component';
import { EdgeComponent } from './views/edge/edge.component';
import { MapComponent } from './views/map/map.component';
import { FogComponent } from './views/fog/fog.component';
import { RouterModule, Routes } from '@angular/router';
import { NgModule } from '@angular/core';

const routes: Routes = [
  {
    path: 'pmap',
    component: MapComponent,
  },
  {
    path: 'pcloud',
    component: CloudComponent,
  },
  {
    path: 'pfog',
    component: FogComponent,
  },
  {
    path: 'pedge',
    component: EdgeComponent,
  },
  {
    path: 'pdevices',
    component: DevicesComponent,
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
